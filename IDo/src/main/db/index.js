import Database from 'better-sqlite3'
import { join } from 'path'
import { app } from 'electron'

const dbPath = join(app.getPath('userData'), 'ido.db')
export const db = new Database(dbPath)
db.pragma('journal_mode = WAL') // 开启 WAL 模式，大幅提升读写性能

// 数据库初始化脚本
export function initDB() {
  const schema = `
    CREATE TABLE IF NOT EXISTS projects (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      color TEXT,
      icon TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS priorities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      color TEXT,
      level INTEGER
    );

    CREATE TABLE IF NOT EXISTS tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      due_date TEXT,
      priority_id INTEGER,
      project_id INTEGER,
      completed INTEGER DEFAULT 0,
      order_index INTEGER DEFAULT 0,
      is_deleted INTEGER DEFAULT 0,
      is_archived INTEGER DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (project_id) REFERENCES projects (id),
      FOREIGN KEY (priority_id) REFERENCES priorities (id)
    );

    CREATE TABLE IF NOT EXISTS subtasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      completed INTEGER DEFAULT 0,
      order_index INTEGER DEFAULT 0,
      is_deleted INTEGER DEFAULT 0,
      FOREIGN KEY (task_id) REFERENCES tasks (id)
    );

    -- 性能优化索引
    CREATE INDEX IF NOT EXISTS idx_tasks_project ON tasks(project_id, is_deleted);
    CREATE INDEX IF NOT EXISTS idx_tasks_priority ON tasks(priority_id, is_deleted);
    CREATE INDEX IF NOT EXISTS idx_tasks_date ON tasks(due_date, is_deleted);
    CREATE INDEX IF NOT EXISTS idx_subtasks_task ON subtasks(task_id, is_deleted);
  `
  db.exec(schema)

  // 插入默认优先级
  const priorityCount = db.prepare('SELECT COUNT(*) as count FROM priorities').get().count
  if (priorityCount === 0) {
    const insert = db.prepare('INSERT INTO priorities (name, color, level) VALUES (?, ?, ?)')
    insert.run('P1', '#ff3b30', 4)
    insert.run('P2', '#ff9500', 3)
    insert.run('P3', '#007aff', 2)
    insert.run('P4', '#8e8e93', 1)
  }

  // 插入默认项目
  const inbox = db.prepare('SELECT id FROM projects WHERE name = ?').get('收件箱')
  if (!inbox) {
    db.prepare('INSERT INTO projects (name, color, icon) VALUES (?, ?, ?)').run('收件箱', '#007aff', 'Inbox')
  }
}
