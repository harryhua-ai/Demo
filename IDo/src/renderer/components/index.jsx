import React, { useState, useEffect, useMemo, useCallback, memo } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useTaskStore } from '../store/useTaskStore'
import {
    Inbox, Plus, CheckCircle2, Circle, Hash, Trash2, Search, Calendar,
    Sun, RefreshCw, MoreVertical, Layout, Zap, ChevronDown, RotateCcw, ChevronRight, MoreHorizontal, X
} from 'lucide-react'

// 农历计算工具函数
const getLunarDay = (dateStr) => {
    try {
        const date = new Date(dateStr)
        const lunarStr = new Intl.DateTimeFormat('zh-u-ca-chinese', { day: 'numeric' }).format(date)
        const dayNum = parseInt(lunarStr)
        const dayMap = ['', '初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十',
            '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十',
            '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十']

        if (dayNum === 1) {
            const monthStr = new Intl.DateTimeFormat('zh-u-ca-chinese', { month: 'long' }).format(date)
            return monthStr
        }
        return dayMap[dayNum] || lunarStr
    } catch (e) {
        return ''
    }
}

export const Sidebar = () => {
    const {
        priorities, projects, currentProjectId, currentPriorityId,
        setCurrentProject, setCurrentPriority, setViewMode, viewMode,
        tasks, setSearchQuery, searchQuery, fetchTasks,
        addPriority, deletePriority, addProject, deleteProject, setCurrentViewDate
    } = useTaskStore()
    const [isRefreshing, setIsRefreshing] = useState(false)
    const [showAddPriority, setShowAddPriority] = useState(false)
    const [newLabelName, setNewLabelName] = useState('')
    const [newLabelColor, setNewLabelColor] = useState('#ff3b30')

    const taskColors = ['#ff3b30', '#ff9500', '#ffcc00', '#34c759', '#007aff', '#5856d6', '#af52de', '#8e8e93']

    const handleRefresh = async () => {
        setIsRefreshing(true)
        await fetchTasks()
        setTimeout(() => setIsRefreshing(false), 600)
    }

    const handleAddPriority = async () => {
        if (!newLabelName.trim()) return
        await addPriority(newLabelName, newLabelColor)
        setNewLabelName('')
        setShowAddPriority(false)
    }

    const inboxCount = tasks.filter(t => !t.due_date && !t.completed && !t.is_deleted).length

    return (
        <div className="sidebar">
            <div className="brand-area">
                <div className="brand-info">
                    <div className="brand-logo">I</div>
                    <div className="brand-name">IDo</div>
                </div>
                <RefreshCw
                    size={16}
                    className={`sidebar-icon refresh-btn ${isRefreshing ? 'rotating' : ''}`}
                    onClick={handleRefresh}
                />
            </div>

            <div className="search-sidebar">
                <Search size={14} color="var(--text-secondary)" />
                <input
                    placeholder="搜索任务..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                />
            </div>

            <div className="sidebar-section">
                <div
                    className={`sidebar-item ${currentProjectId === 'TODAY' ? 'active' : ''}`}
                    onClick={() => {
                        setCurrentProject('TODAY')
                        setCurrentViewDate(new Date().toISOString().split('T')[0])
                    }}
                >
                    <Sun size={18} color="var(--accent)" />
                    <span>Day Todo</span>
                </div>
                <div
                    className={`sidebar-item ${currentProjectId === 'ALL_PLAN' ? 'active' : ''}`}
                    onClick={() => setCurrentProject('ALL_PLAN')}
                >
                    <Calendar size={18} color="#007aff" />
                    <span>最近待办</span>
                </div>
                <div
                    className={`sidebar-item ${viewMode === 'calendar' ? 'active' : ''}`}
                    onClick={() => setViewMode('calendar')}
                >
                    <Layout size={18} color="#ff9500" />
                    <span>日程概览</span>
                </div>
                <div
                    className={`sidebar-item ${currentProjectId === 'FUTURE' ? 'active' : ''}`}
                    onClick={() => setCurrentProject('FUTURE')}
                >
                    <Inbox size={18} color="#4cd964" />
                    <span>待办箱</span>
                    {inboxCount > 0 && <span className="badge">{inboxCount}</span>}
                </div>
            </div>

            <div className="sidebar-section">
                <div
                    className="sidebar-item add-trigger"
                    onClick={() => setShowAddPriority(!showAddPriority)}
                >
                    <Plus size={16} color="var(--accent)" />
                    <span style={{ color: 'var(--accent)', fontWeight: 600 }}>创建新标签</span>
                </div>

                {showAddPriority && (
                    <div className="priority-create-box">
                        <input
                            autoFocus
                            placeholder="标签名称..."
                            value={newLabelName}
                            onChange={(e) => setNewLabelName(e.target.value)}
                            onKeyDown={(e) => e.key === 'Enter' && handleAddPriority()}
                        />
                        <div className="color-picker-grid">
                            {taskColors.map(c => (
                                <div
                                    key={c}
                                    className={`color-dot-opt ${newLabelColor === c ? 'active' : ''}`}
                                    style={{ backgroundColor: c }}
                                    onClick={(e) => {
                                        e.stopPropagation()
                                        setNewLabelColor(c)
                                    }}
                                />
                            ))}
                        </div>
                        <div className="form-actions">
                            <button className="btn-cancel" onClick={(e) => {
                                e.stopPropagation()
                                setShowAddPriority(false)
                            }}>取消</button>
                            <button className="btn-confirm" onClick={handleAddPriority}>创建</button>
                        </div>
                    </div>
                )}

                <div
                    className={`sidebar-item ${currentPriorityId === null && !currentProjectId ? 'active' : ''}`}
                    onClick={() => setCurrentPriority(null)}
                >
                    <Circle size={16} color="#ccc" />
                    <span>全部任务</span>
                </div>
                {priorities.map(p => (
                    <div
                        key={p.id}
                        className={`sidebar-item ${currentPriorityId === p.id ? 'active' : ''}`}
                        onClick={() => setCurrentPriority(p.id)}
                    >
                        <Circle size={14} fill={p.color} color={p.color} />
                        <span>{p.name}</span>
                        {currentPriorityId === p.id && (
                            <Trash2
                                size={12}
                                className="item-delete"
                                onClick={(e) => {
                                    e.stopPropagation()
                                    if (confirm(`确定删除标签 "${p.name}" 吗？`)) deletePriority(p.id)
                                }}
                            />
                        )}
                    </div>
                ))}
            </div>

            <div className="sidebar-section">
                {projects.map(proj => (
                    <div
                        key={proj.id}
                        className={`sidebar-item project-item ${currentProjectId === proj.id ? 'active' : ''}`}
                        onClick={() => setCurrentProject(proj.id)}
                    >
                        <Hash size={16} color={proj.color || '#999'} />
                        <span>{proj.name}</span>
                        <Trash2
                            size={12}
                            className="item-delete"
                            onClick={(e) => {
                                e.stopPropagation()
                                if (confirm('确定删除项目？')) deleteProject(proj.id)
                            }}
                        />
                    </div>
                ))}
            </div>

            <div className="sidebar-footer">
                <div
                    className={`footer-btn ${currentProjectId === 'DONE' ? 'active' : ''}`}
                    onClick={() => setCurrentProject('DONE')}
                >
                    <CheckCircle2 size={16} /> 已达成
                </div>
                <div
                    className={`footer-btn ${currentProjectId === 'TRASH' ? 'active' : ''}`}
                    onClick={() => setCurrentProject('TRASH')}
                >
                    <Trash2 size={16} /> 回收站
                </div>
            </div>
        </div>
    )
}

const TaskGroup = memo(({
    task,
    currentProjectId,
    expanded,
    subtasks,
    onToggleExpand,
    onToggleTask,
    onClick,
    onToggleSub,
    onDeleteSub,
    onAddSubInList
}) => {
    const { restoreTask, permanentDeleteTask } = useTaskStore()

    return (
        <motion.div
            className="task-group"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95 }}
            transition={{ duration: 0.2 }}
        >
            <div className="task-item" onClick={onClick}>
                <div
                    className="checkbox"
                    style={{ width: 20, height: 20, flexShrink: 0 }}
                    onClick={(e) => {
                        e.stopPropagation()
                        if (currentProjectId === 'TRASH') return
                        onToggleTask(task.id, !task.completed)
                    }}
                >
                    {task.completed ?
                        <CheckCircle2 size={20} color="var(--accent)" /> :
                        <Circle size={20} color="var(--text-secondary)" />
                    }
                </div>

                <div
                    className={`expand-trigger ${expanded ? 'expanded' : ''}`}
                    onClick={onToggleExpand}
                >
                    <ChevronDown size={14} color="#bbb" />
                </div>

                <div className="priority-indicator" style={{ backgroundColor: task.priority_color || 'transparent' }}></div>
                <div className="task-main-info">
                    <span className={task.completed ? 'completed' : ''}>{task.title}</span>
                    {task.total_subtasks > 0 && !expanded && (
                        <div className="subtasks-summary">
                            {task.completed_subtasks}/{task.total_subtasks} 子任务
                        </div>
                    )}
                </div>
                {currentProjectId === 'TRASH' && (
                    <div className="trash-actions">
                        <RotateCcw
                            size={16}
                            className="action-icon restore"
                            onClick={(e) => {
                                e.stopPropagation()
                                restoreTask(task.id)
                            }}
                        />
                        <Trash2
                            size={16}
                            className="action-icon delete-perm"
                            onClick={(e) => {
                                e.stopPropagation()
                                if (confirm('彻底删除任务？此操作不可逆。')) permanentDeleteTask(task.id)
                            }}
                        />
                    </div>
                )}
            </div>

            <AnimatePresence>
                {expanded && (
                    <motion.div
                        className="nested-subtasks"
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: 'auto', opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        transition={{ duration: 0.2, ease: "easeInOut" }}
                        style={{ overflow: 'hidden' }}
                    >
                        {(subtasks || []).map(s => (
                            <div key={s.id} className="subtask-row">
                                <div onClick={(e) => { e.stopPropagation(); onToggleSub(task.id, s.id, !s.completed); }}>
                                    {s.completed ?
                                        <CheckCircle2 size={16} color="var(--accent)" /> :
                                        <Circle size={16} color="var(--text-secondary)" />
                                    }
                                </div>
                                <span className={s.completed ? 'completed' : ''}>{s.title}</span>
                                <Trash2
                                    size={12}
                                    className="sub-delete"
                                    onClick={(e) => { e.stopPropagation(); onDeleteSub(task.id, s.id); }}
                                />
                            </div>
                        ))}
                        <div className="add-subtask-inline" onClick={(e) => e.stopPropagation()}>
                            <Plus size={14} color="#bbb" />
                            <input
                                placeholder="添加子任务..."
                                onKeyDown={(e) => {
                                    if (e.key === 'Enter' && e.target.value.trim()) {
                                        onAddSubInList(e, task.id)
                                    }
                                }}
                            />
                        </div>
                    </motion.div>
                )}
            </AnimatePresence>
        </motion.div>
    )
})

export const List = ({ onSelectTask }) => {
    const {
        priorities, tasks, toggleTask, addTask, fetchTasks,
        viewMode, currentProjectId, currentPriorityId,
        fetchSubtasks, toggleSubtask, deleteSubtask, addSubtask,
        currentViewDate, setCurrentViewDate, searchQuery
    } = useTaskStore()

    const [newTitle, setNewTitle] = useState('')
    const [selectedInputPriority, setSelectedInputPriority] = useState(null)
    const [showPriorityPicker, setShowPriorityPicker] = useState(false)
    const [expandedTasks, setExpandedTasks] = useState(new Set())
    const [taskSubtasks, setTaskSubtasks] = useState({})

    useEffect(() => {
        fetchTasks()
    }, [currentViewDate, currentProjectId, currentPriorityId, searchQuery, viewMode])

    const handleAdd = (e) => {
        if (e.key === 'Enter' && newTitle.trim()) {
            addTask(newTitle.trim(), selectedInputPriority?.id)
            setNewTitle('')
            setSelectedInputPriority(null)
            setShowPriorityPicker(false)
        }
    }

    const getWeekDays = () => {
        const now = new Date()
        const dayOfWeek = now.getDay()
        const startOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek
        const days = []
        for (let i = 0; i < 7; i++) {
            const d = new Date(now)
            d.setDate(now.getDate() + startOffset + i)
            const dateStr = d.toISOString().split('T')[0]
            days.push({
                full: dateStr,
                num: d.getDate().toString().padStart(2, '0'),
                isToday: dateStr === new Date().toISOString().split('T')[0]
            })
        }
        return days
    }

    const weekDays = useMemo(() => getWeekDays(), [])
    const displayDateStr = () => {
        const d = new Date(currentViewDate)
        const isToday = currentViewDate === new Date().toISOString().split('T')[0]
        return `${d.getMonth() + 1}月${d.getDate()}日 ${isToday ? '今天' : ''}`
    }

    const toggleExpandOnly = useCallback(async (taskId) => {
        setExpandedTasks(prev => {
            const newExpanded = new Set(prev)
            if (newExpanded.has(taskId)) {
                newExpanded.delete(taskId)
            } else {
                newExpanded.add(taskId)
                fetchSubtasks(taskId).then(subs => {
                    setTaskSubtasks(prevSubs => ({ ...prevSubs, [taskId]: subs }))
                })
            }
            return newExpanded
        })
    }, [fetchSubtasks])

    const toggleExpand = useCallback(async (e, taskId) => {
        e.stopPropagation()
        await toggleExpandOnly(taskId)
    }, [toggleExpandOnly])

    const handleTaskItemClick = useCallback((task) => {
        onSelectTask(task)
        toggleExpandOnly(task.id)
    }, [onSelectTask, toggleExpandOnly])

    const handleToggleSub = useCallback(async (taskId, subId, completed) => {
        await toggleSubtask(taskId, subId, completed)
        const subs = await fetchSubtasks(taskId)
        setTaskSubtasks(prev => ({ ...prev, [taskId]: subs }))
    }, [toggleSubtask, fetchSubtasks])

    const handleDeleteSub = useCallback(async (taskId, subId) => {
        await deleteSubtask(taskId, subId)
        const subs = await fetchSubtasks(taskId)
        setTaskSubtasks(prev => ({ ...prev, [taskId]: subs }))
    }, [deleteSubtask, fetchSubtasks])

    const handleAddSubInList = useCallback(async (e, taskId) => {
        const title = e.target.value.trim()
        if (title) {
            await addSubtask(taskId, title)
            const subs = await fetchSubtasks(taskId)
            setTaskSubtasks(prev => ({ ...prev, [taskId]: subs }))
            e.target.value = ''
        }
    }, [addSubtask, fetchSubtasks])

    if (viewMode === 'calendar') return <CalendarView onSelectTask={onSelectTask} />

    return (
        <div className="list-view">
            <div className={`list-header ${currentProjectId === 'TODAY' ? 'day-todo-header' : 'generic-header'}`}>
                {currentProjectId === 'TODAY' ? (
                    <>
                        <div className="date-nav">
                            {weekDays.map((d, idx) => (
                                <div
                                    key={idx}
                                    className={`date-item ${currentViewDate === d.full ? 'active' : ''}`}
                                    onClick={() => setCurrentViewDate(d.full)}
                                >
                                    {d.isToday ? '今' : d.num}
                                </div>
                            ))}
                        </div>
                        <div
                            className="current-date-label"
                            onClick={() => setCurrentViewDate(new Date().toISOString().split('T')[0])}
                        >
                            {displayDateStr()} <Sun size={14} color="#ff9500" />
                        </div>
                    </>
                ) : (
                    <div className="view-title">
                        {currentProjectId === 'ALL_PLAN' && '最近待办'}
                        {currentProjectId === 'FUTURE' && '待办箱'}
                        {currentProjectId === 'DONE' && '已完成'}
                        {currentProjectId === 'TRASH' && '回收站'}
                        {typeof currentProjectId === 'number' && '项目详情'}
                        {!currentProjectId && currentPriorityId && '优先级筛选'}
                    </div>
                )}
            </div>

            <div className={`add-task-hero ${currentProjectId === 'TODAY' ? 'hero-styled' : ''}`}>
                <div className="hero-input-wrapper">
                    <div
                        className="input-priority-picker"
                        onClick={(e) => {
                            e.stopPropagation()
                            setShowPriorityPicker(!showPriorityPicker)
                        }}
                    >
                        <Circle
                            size={20}
                            color={selectedInputPriority ? selectedInputPriority.color : "#ccc"}
                            fill={selectedInputPriority ? selectedInputPriority.color : "transparent"}
                        />

                        {showPriorityPicker && (
                            <div className="priority-popover">
                                <div
                                    className="popover-option"
                                    onClick={(e) => {
                                        e.stopPropagation()
                                        setSelectedInputPriority(null)
                                        setShowPriorityPicker(false)
                                    }}
                                >
                                    <Circle size={20} color="#ccc" />
                                </div>
                                {priorities.map(p => (
                                    <div
                                        key={p.id}
                                        className="popover-option"
                                        onClick={(e) => {
                                            e.stopPropagation()
                                            setSelectedInputPriority(p)
                                            setShowPriorityPicker(false)
                                        }}
                                    >
                                        <Circle size={20} fill={p.color} color={p.color} />
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>

                    <input
                        placeholder="在此添加内容，回车创建事件..."
                        value={newTitle}
                        onChange={e => setNewTitle(e.target.value)}
                        onKeyDown={handleAdd}
                    />
                </div>
            </div>

            <div className="task-scroll">
                <AnimatePresence mode="popLayout">
                    {tasks.map(task => (
                        <TaskGroup
                            key={task.id}
                            task={task}
                            currentProjectId={currentProjectId}
                            expanded={expandedTasks.has(task.id)}
                            subtasks={taskSubtasks[task.id] || []}
                            onToggleExpand={(e) => toggleExpand(e, task.id)}
                            onToggleTask={toggleTask}
                            onClick={() => currentProjectId !== 'TRASH' && handleTaskItemClick(task)}
                            onToggleSub={handleToggleSub}
                            onDeleteSub={handleDeleteSub}
                            onAddSubInList={handleAddSubInList}
                        />
                    ))}
                </AnimatePresence>
            </div>
        </div>
    )
}

const CalendarView = ({ onSelectTask }) => {
    const { tasks, fetchTasks, setSelectedDate, selectedDate } = useTaskStore()
    const [currentBaseDate, setCurrentBaseDate] = useState(new Date())

    useEffect(() => {
        fetchTasks()
    }, [currentBaseDate])

    const year = currentBaseDate.getFullYear()
    const month = currentBaseDate.getMonth()

    const firstDay = new Date(year, month, 1).getDay()
    const daysInMonth = new Date(year, month + 1, 0).getDate()
    const prevMonthLastDay = new Date(year, month, 0).getDate()

    const calendarDays = useMemo(() => {
        const days = []
        const startDay = firstDay === 0 ? 6 : firstDay - 1
        for (let i = startDay - 1; i >= 0; i--) {
            days.push({ day: prevMonthLastDay - i, month: month - 1, isCurrent: false })
        }
        for (let i = 1; i <= daysInMonth; i++) {
            days.push({ day: i, month: month, isCurrent: true })
        }
        const remaining = 42 - days.length
        for (let i = 1; i <= remaining; i++) {
            days.push({ day: i, month: month + 1, isCurrent: false })
        }
        return days
    }, [firstDay, daysInMonth, prevMonthLastDay, month])

    const changeMonth = (offset) => {
        const nextDate = new Date(currentBaseDate)
        nextDate.setMonth(nextDate.getMonth() + offset)
        setCurrentBaseDate(nextDate)
    }

    const formatTaskDate = (d, m) => {
        const dateObj = new Date(year, m, d)
        return dateObj.toISOString().split('T')[0]
    }

    return (
        <div className="calendar-view">
            <div className="calendar-header">
                <div className="month-nav-reworked">
                    <button className="nav-arrow" onClick={() => changeMonth(-1)}>&lt;</button>
                    <h2>{year}年 {month + 1}月</h2>
                    <button className="nav-arrow" onClick={() => changeMonth(1)}>&gt;</button>
                </div>
                <button className="today-btn" onClick={() => setCurrentBaseDate(new Date())}>回到今天</button>
            </div>

            <div className="calendar-grid-labels">
                {['一', '二', '三', '四', '五', '六', '日'].map(d => <div key={d}>{d}</div>)}
            </div>

            <div className="calendar-grid-main">
                {calendarDays.map((dateInfo, idx) => {
                    const dateStr = formatTaskDate(dateInfo.day, dateInfo.month)
                    const dayTasks = tasks.filter(t => t.due_date && t.due_date.startsWith(dateStr))

                    return (
                        <div
                            key={idx}
                            className={`calendar-day-cell ${!dateInfo.isCurrent ? 'other-month' : ''} ${dateStr === selectedDate ? 'selected' : ''}`}
                            onClick={() => setSelectedDate(dateStr)}
                        >
                            <div className="day-info">
                                <span className="day-num">{dateInfo.day}</span>
                                <span className="lunar">{getLunarDay(dateStr)}</span>
                            </div>
                            <div className="day-tasks-preview">
                                {dayTasks.slice(0, 3).map(t => (
                                    <div
                                        key={t.id}
                                        className="task-pill"
                                        onClick={(e) => {
                                            e.stopPropagation()
                                            onSelectTask(t)
                                        }}
                                        style={{ borderLeftColor: t.priority_color }}
                                    >
                                        {t.title}
                                    </div>
                                ))}
                                {dayTasks.length > 3 && <div className="more-count">+{dayTasks.length - 3} 更多</div>}
                            </div>
                        </div>
                    )
                })}
            </div>
        </div>
    )
}

export const Detail = ({ task, onDelete }) => {
    const { updateTask, deleteTask, priorities, tasks } = useTaskStore()
    const [editDesc, setEditDesc] = useState('')
    const [editDate, setEditDate] = useState('')

    useEffect(() => {
        if (task && !tasks.find(t => t.id === task.id)) {
            if (onDelete) onDelete()
        }
    }, [tasks, task])

    useEffect(() => {
        if (task) {
            setEditDesc(task.description || '')
            setEditDate(task.due_date ? task.due_date.split('T')[0] : '')
        }
    }, [task])

    const handleUpdateDesc = () => {
        if (editDesc !== task.description) {
            updateTask(task.id, { description: editDesc })
        }
    }

    const handleUpdateDate = (date) => {
        setEditDate(date)
        updateTask(task.id, { due_date: date })
    }

    const handleDelete = async () => {
        await deleteTask(task.id)
        if (onDelete) onDelete()
    }

    if (!task) return (
        <div className="detail-empty">
            <div className="empty-state">
                <div className="empty-icon">✓</div>
                <p>选择一个任务查看详情</p>
            </div>
        </div>
    )

    return (
        <div className="detail-view">
            <div className="detail-header">
                <div className="priority-selector">
                    <div
                        className={`p-dot none ${!task.priority_id ? 'active' : ''}`}
                        onClick={() => updateTask(task.id, { priority_id: null })}
                        title="无优先级"
                    />
                    {priorities.map(p => (
                        <div
                            key={p.id}
                            className={`p-dot ${task.priority_id === p.id ? 'active' : ''}`}
                            style={{ backgroundColor: p.color }}
                            onClick={() => updateTask(task.id, { priority_id: p.id })}
                            title={p.name}
                        />
                    ))}
                </div>
                <button className="delete-btn" onClick={handleDelete}>
                    <Trash2 size={18} />
                </button>
            </div>
            <div className="detail-content">
                <h2 className={task.completed ? 'completed' : ''}>{task.title}</h2>

                <div className="detail-row">
                    <div className="detail-field">
                        <label>到期日</label>
                        <input
                            type="date"
                            className="date-picker-minimal"
                            value={editDate}
                            onChange={(e) => handleUpdateDate(e.target.value)}
                        />
                    </div>
                </div>

                <div className="detail-section">
                    <label>描述</label>
                    <textarea
                        className="desc-editor"
                        placeholder="添加任务描述..."
                        value={editDesc}
                        onChange={(e) => setEditDesc(e.target.value)}
                        onBlur={handleUpdateDesc}
                    />
                </div>
            </div>
        </div>
    )
}
