import { contextBridge, ipcRenderer } from 'electron'

// 暴露出安全的 API 给渲染进程
const api = {
    // 数据库操作接口占位
    db: {
        query: (sql, params) => ipcRenderer.invoke('db:query', { sql, params }),
        execute: (sql, params) => ipcRenderer.invoke('db:execute', { sql, params })
    }
}

if (process.contextIsolated) {
    try {
        contextBridge.exposeInMainWorld('api', api)
    } catch (error) {
        console.error(error)
    }
} else {
    window.api = api
}
