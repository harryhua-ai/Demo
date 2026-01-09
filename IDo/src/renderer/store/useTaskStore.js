import { create } from 'zustand'

export const useTaskStore = create((set, get) => ({
    tasks: [],
    projects: [],
    priorities: [],
    currentProjectId: null,
    currentPriorityId: null,
    searchQuery: '',
    viewMode: 'list', // 'list' or 'calendar'
    selectedDate: null,
    currentViewDate: new Date().toISOString().split('T')[0],
    loading: false,
    _searchTimer: null, // 内部变量，控制防抖

    fetchPriorities: async () => {
        const priorities = await window.api.db.query('SELECT * FROM priorities ORDER BY level DESC')
        set({ priorities })
    },

    fetchProjects: async () => {
        const projects = await window.api.db.query('SELECT * FROM projects')
        set({ projects })
        if (projects.length > 0 && !get().currentProjectId) {
            set({ currentProjectId: projects[0].id })
        }
        get().fetchPriorities()
    },

    fetchTasks: async () => {
        set({ loading: true })
        const { currentProjectId, currentPriorityId, searchQuery, selectedDate, viewMode, currentViewDate } = get()
        const today = new Date().toISOString().split('T')[0]
        const filterDate = currentViewDate || today

        let sql = `
            SELECT t.*, 
            p.name as priority_name, p.color as priority_color, p.level as priority_level,
            (SELECT COUNT(*) FROM subtasks s WHERE s.task_id = t.id AND s.is_deleted = 0) as total_subtasks,
            (SELECT COUNT(*) FROM subtasks s WHERE s.task_id = t.id AND s.completed = 1 AND s.is_deleted = 0) as completed_subtasks
            FROM tasks t 
            LEFT JOIN priorities p ON t.priority_id = p.id
            WHERE 1=1
        `
        const params = []

        // 回收站模式特殊处理
        if (currentProjectId === 'TRASH') {
            sql += ' AND t.is_deleted = 1'
        } else {
            sql += ' AND t.is_deleted = 0'

            // 优先级过滤优先
            if (currentPriorityId) {
                sql += ' AND t.priority_id = ?'
                params.push(currentPriorityId)
            }
            // 视图与分类逻辑
            else if (viewMode === 'calendar') {
                if (selectedDate) {
                    sql += ' AND date(t.due_date) = date(?)'
                    params.push(selectedDate)
                } else {
                    sql += ' AND t.due_date IS NOT NULL'
                }
            } else {
                switch (currentProjectId) {
                    case 'TODAY':
                        sql += ' AND date(t.due_date) = date(?)'
                        params.push(filterDate)
                        break;
                    case 'ALL_PLAN':
                        sql += ' AND t.due_date IS NOT NULL AND t.completed = 0'
                        break;
                    case 'DONE':
                        sql += ' AND t.completed = 1'
                        break;
                    case 'FUTURE':
                        sql += ' AND t.due_date IS NULL AND t.completed = 0'
                        break;
                    case 'INBOX':
                    default:
                        if (!currentProjectId) {
                            sql += ' AND t.completed = 0'
                        } else if (typeof currentProjectId === 'number') {
                            sql += ' AND t.project_id = ?'
                            params.push(currentProjectId)
                        }
                        break;
                }
            }
        }

        if (searchQuery) {
            sql += ' AND t.title LIKE ?'
            params.push(`%${searchQuery}%`)
        }

        sql += ' ORDER BY p.level DESC, t.order_index ASC, t.created_at DESC'

        const tasks = await window.api.db.query(sql, params)
        set({ tasks, loading: false })
    },

    setSearchQuery: (query) => {
        set({ searchQuery: query })
        // 清除旧定时器并设置防抖查询 (300ms)
        const timer = get()._searchTimer
        if (timer) clearTimeout(timer)
        const newTimer = setTimeout(() => {
            get().fetchTasks()
        }, 300)
        set({ _searchTimer: newTimer })
    },

    updateTask: async (id, updates) => {
        const fields = Object.keys(updates).map(k => `${k} = ?`).join(', ')
        const params = [...Object.values(updates), id]
        await window.api.db.execute(`UPDATE tasks SET ${fields}, updated_at = CURRENT_TIMESTAMP WHERE id = ?`, params)
        get().fetchTasks()
    },

    updateTaskPriority: async (taskId, priorityId) => {
        get().updateTask(taskId, { priority_id: priorityId })
    },

    fetchSubtasks: async (taskId) => {
        const sql = 'SELECT * FROM subtasks WHERE task_id = ? AND is_deleted = 0 ORDER BY order_index ASC'
        return await window.api.db.query(sql, [taskId])
    },

    addSubtask: async (taskId, title) => {
        const sql = 'INSERT INTO subtasks (task_id, title) VALUES (?, ?)'
        await window.api.db.execute(sql, [taskId, title])
        get().fetchTasks()
    },

    toggleSubtask: async (taskId, subtaskId, completed) => {
        const sql = 'UPDATE subtasks SET completed = ? WHERE id = ?'
        await window.api.db.execute(sql, [completed ? 1 : 0, subtaskId])

        // 联动逻辑：检查是否所有子任务都已完成
        if (completed) {
            const subs = await window.api.db.query('SELECT completed FROM subtasks WHERE task_id = ? AND is_deleted = 0', [taskId])
            const allDone = subs.every(s => s.completed === 1)
            if (allDone && subs.length > 0) {
                await window.api.db.execute('UPDATE tasks SET completed = 1, updated_at = CURRENT_TIMESTAMP WHERE id = ?', [taskId])
            }
        }

        get().fetchTasks()
    },

    deleteSubtask: async (taskId, subtaskId) => {
        const sql = 'UPDATE subtasks SET is_deleted = 1 WHERE id = ?'
        await window.api.db.execute(sql, [subtaskId])
        get().fetchTasks()
    },

    addTask: async (title, manualPriorityId = null) => {
        const { currentProjectId, currentPriorityId, fetchTasks, currentViewDate } = get()
        const today = new Date().toISOString().split('T')[0]
        let dueDate = currentViewDate || null
        let priorityId = manualPriorityId || currentPriorityId || null

        // 智能填充属性 (如果是 TODAY 视图且未传日期，默认今天)
        if (!dueDate && currentProjectId === 'TODAY') {
            dueDate = today
        } else if (currentProjectId === 'ALL_PLAN' && !dueDate) {
            dueDate = today
        }

        const sql = 'INSERT INTO tasks (title, due_date, priority_id, created_at, updated_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)'
        await window.api.db.execute(sql, [title, dueDate, priorityId])
        fetchTasks()
    },

    toggleTask: async (id, completed) => {
        const sql = 'UPDATE tasks SET completed = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?'
        await window.api.db.execute(sql, [completed ? 1 : 0, id])
        get().fetchTasks()
    },

    deleteTask: async (id) => {
        await window.api.db.execute('UPDATE tasks SET is_deleted = 1 WHERE id = ?', [id])
        get().fetchTasks()
    },

    restoreTask: async (id) => {
        await window.api.db.execute('UPDATE tasks SET is_deleted = 0 WHERE id = ?', [id])
        get().fetchTasks()
    },

    permanentDeleteTask: async (id) => {
        await window.api.db.execute('DELETE FROM tasks WHERE id = ?', [id])
        await window.api.db.execute('DELETE FROM subtasks WHERE task_id = ?', [id])
        get().fetchTasks()
    },

    addProject: async (name, color) => {
        const sql = 'INSERT INTO projects (name, color) VALUES (?, ?)'
        await window.api.db.execute(sql, [name, color])
        get().fetchProjects()
    },

    deleteProject: async (id) => {
        const sql = 'DELETE FROM projects WHERE id = ?'
        await window.api.db.execute(sql, [id])
        if (get().currentProjectId === id) set({ currentProjectId: null })
        get().fetchProjects()
        get().fetchTasks()
    },

    setCurrentProject: (id) => {
        set({ currentProjectId: id, currentPriorityId: null, viewMode: 'list' })
        get().fetchTasks()
    },

    setCurrentPriority: (id) => {
        set({ currentPriorityId: id, currentProjectId: null, viewMode: 'list' })
        get().fetchTasks()
    },

    setViewMode: (mode) => set({ viewMode: mode }),

    setSelectedDate: (date) => {
        set({ selectedDate: date })
        if (date) set({ viewMode: 'calendar' })
        get().fetchTasks()
    },

    setCurrentViewDate: (date) => {
        set({ currentViewDate: date })
        if (get().currentProjectId === 'TODAY') get().fetchTasks()
    },

    // 标签管理动作
    addPriority: async (name, color, level = 1) => {
        const sql = 'INSERT INTO priorities (name, color, level) VALUES (?, ?, ?)'
        await window.api.db.execute(sql, [name, color, level])
        get().fetchPriorities()
    },

    updatePriority: async (id, updates) => {
        const fields = Object.keys(updates).map(k => `${k} = ?`).join(', ')
        const params = [...Object.values(updates), id]
        await window.api.db.execute(`UPDATE priorities SET ${fields} WHERE id = ?`, params)
        get().fetchPriorities()
        get().fetchTasks() // 刷新任务列表中的颜色/名称
    },

    deletePriority: async (id) => {
        await window.api.db.execute('DELETE FROM priorities WHERE id = ?', [id])
        if (get().currentPriorityId === id) set({ currentPriorityId: null })
        get().fetchPriorities()
        get().fetchTasks()
    }
}))
