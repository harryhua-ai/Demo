import { app, shell, BrowserWindow, ipcMain } from 'electron'
import { join } from 'path'
import { electronApp, optimizer, is } from '@electron-toolkit/utils'

app.setName('IDo')

function createWindow() {
    const mainWindow = new BrowserWindow({
        width: 1000,
        height: 700,
        show: false,
        autoHideMenuBar: true,
        title: 'IDo',
        titleBarStyle: 'hiddenInset', // macOS 风格无标题栏
        icon: join(__dirname, '../../resources/icon.png'),
        webPreferences: {
            preload: join(__dirname, '../preload/index.js'),
            sandbox: false
        }
    })

    // macOS 特殊处理：更新 Dock 图标
    if (process.platform === 'darwin') {
        app.dock.setIcon(join(__dirname, '../../resources/icon.png'))
    }

    mainWindow.on('ready-to-show', () => {
        mainWindow.show()
    })

    mainWindow.webContents.setWindowOpenHandler((details) => {
        shell.openExternal(details.url)
        return { action: 'deny' }
    })

    // HMR 开发环境或生产环境加载
    if (is.dev && process.env['ELECTRON_RENDERER_URL']) {
        mainWindow.loadURL(process.env['ELECTRON_RENDERER_URL'])
    } else {
        mainWindow.loadFile(join(__dirname, '../renderer/index.html'))
    }
}

import { initDB } from './db/index'
import { setupIPC } from './ipc/index'

import { globalShortcut } from 'electron'

app.whenReady().then(() => {
    // 初始化数据库
    initDB()
    // 设置 IPC
    setupIPC()

    // 注册全局快捷键: Option + Space
    const ret = globalShortcut.register('Alt+Space', () => {
        const win = BrowserWindow.getAllWindows()[0]
        if (win) {
            if (win.isVisible() && win.isFocused()) {
                win.hide()
            } else {
                win.show()
                win.focus()
            }
        }
    })

    if (!ret) {
        console.log('Shortcut registration failed')
    }

    // F12 开发工具快捷键
    app.on('browser-window-created', (_, window) => {
        optimizer.watchWindowShortcuts(window)
    })

    createWindow()

    app.on('activate', function () {
        if (BrowserWindow.getAllWindows().length === 0) createWindow()
    })
})

app.on('will-quit', () => {
    // 注销所有快捷键
    globalShortcut.unregisterAll()
})

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit()
    }
})
