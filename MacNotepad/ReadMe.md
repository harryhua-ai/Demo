# MacNotepad

MacNotepad 是一款为 macOS 精心打造的现代化文本编辑器，旨在提供类似 Notepad++ 的强大功能与 macOS 的极致原生体验。

![App Icon](MacNotepad.app/Contents/Resources/AppIcon.icns)

## 核心功能

- **多语言支持**：完美支持简体中文与英文，可在“视图”菜单中无缝切换。
- **现代化 UI**：采用 macOS 原生设计语言，支持分屏、全屏及黑暗模式。
- **专业工具**：
  - **大小写转换**：大写、小写、标题格式。
  - **行操作**：排序、反转、去重、删除空行、删除行尾空格。
  - **编码与转换**：Base64 编解码、URL 编解码、文本转十六进制。
  - **格式转换**：支持 Windows (CRLF) 与 Unix (LF) 换行符转换，支持 GBK 编码转换。
- **悬浮查找/替换**：独立的悬浮式查找面板，支持正则表达式与转义字符模式。
- **持久化会话**：自动保存并恢复上次关闭时的所有标签页。
- **代码高亮**：支持多种编程语言的实时语法高亮与自动格式化。

## 安装指南

1. **直接运行**：您可以在此目录中直接双击 `MacNotepad.app` 运行。
2. **移动到应用程序**：为了方便使用，您可以将 `MacNotepad.app` 拖入 `/Applications` 文件夹中。

## 系统要求

- macOS 11.0 或更高版本
- Apple Silicon (M1/M2/M3) 或 Intel 处理器 (Universal)

## 开发与编译

本项目基于 Swift 6 与 SwiftUI 构建：

```bash
# 编译
swift build -c release

# 打包
# 程序已打包在当前目录下的 MacNotepad.app 中
```

---

感谢使用 MacNotepad！
