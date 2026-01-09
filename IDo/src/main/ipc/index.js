import { db } from '../db/index'
import { ipcMain } from 'electron'

export function setupIPC() {
    // 通用查询接口
    ipcMain.handle('db:query', (event, { sql, params }) => {
        try {
            return db.prepare(sql).all(params || [])
        } catch (error) {
            console.error('DB Query Error:', error)
            throw error
        }
    })

    // 通用执行接口 (INSERT, UPDATE, DELETE)
    ipcMain.handle('db:execute', (event, { sql, params }) => {
        try {
            const result = db.prepare(sql).run(params || [])
            return { lastInsertRowid: result.lastInsertRowid, changes: result.changes }
        } catch (error) {
            console.error('DB Execute Error:', error)
            throw error
        }
    })
}
