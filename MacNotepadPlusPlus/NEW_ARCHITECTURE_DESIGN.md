# Notepad++ macOS 新架构设计

## 应用程序架构概述

### 核心设计原则
1. **模块化设计**：每个功能模块独立，便于维护和扩展
2. **macOS最佳实践**：遵循Apple的Human Interface Guidelines
3. **性能优化**：高效的内存管理和文本渲染
4. **功能完整性**：继承Notepad++ Windows版本的核心功能

### 主要组件架构

```
Notepad++ macOS App
├── Application Layer (Objective-C/Cocoa)
│   ├── AppDelegate (应用程序入口点)
│   ├── MainWindowController (主窗口控制器)
│   ├── DocumentManager (文档管理器)
│   └── MenuManager (菜单管理器)
├── UI Layer (Cocoa UI)
│   ├── TabbedDocumentView (标签式文档视图)
│   ├── ScintillaEditorView (文本编辑器视图)
│   ├── StatusBar (状态栏)
│   └── Toolbar (工具栏)
├── Text Processing Layer (C++/Scintilla)
│   ├── ScintillaEngine (Scintilla引擎封装)
│   ├── SyntaxHighlighter (语法高亮器)
│   ├── SearchReplaceEngine (搜索替换引擎)
│   └── CodeFoldingManager (代码折叠管理器)
└── Utility Layer (工具层)
    ├── FileManager (文件管理器)
    ├── PreferencesManager (偏好设置管理器)
    └── PluginManager (插件管理器)
```

## 核心功能实现计划

### 第一阶段：基础架构 (High Priority)
1. **主应用程序框架**
   - AppDelegate重新设计
   - 主窗口控制器实现
   - 应用程序生命周期管理

2. **文档管理系统**
   - 多文档标签页实现
   - 文档打开/保存功能
   - 最近文件列表

3. **文本编辑核心**
   - Scintilla引擎集成
   - 基础文本编辑功能

### 第二阶段：用户界面 (High Priority)
1. **主窗口布局**
   - 标签页界面
   - 状态栏显示
   - 工具栏配置

2. **菜单系统**
   - 标准菜单项实现
   - 快捷键绑定

### 第三阶段：高级功能 (Medium Priority)
1. **语法高亮**
   - 多语言支持
   - 主题配置

2. **搜索替换**
   - 正则表达式支持
   - 批量替换功能

3. **代码折叠**
   - 自动折叠逻辑
   - 手动折叠控制

### 第四阶段：增强功能 (Low Priority)
1. **插件系统**
2. **主题系统**
3. **高级设置**

## 技术实现细节

### 文件结构规划
```
NewNotepadPlusPlus/
├── App/
│   ├── AppDelegate.h/.mm
│   ├── MainWindowController.h/.mm
│   └── DocumentManager.h/.mm
├── Views/
│   ├── TabbedDocumentView.h/.mm
│   ├── ScintillaEditorView.h/.mm
│   └── StatusBar.h/.mm
├── Models/
│   ├── Document.h/.mm
│   ├── Preferences.h/.mm
│   └── SyntaxTheme.h/.mm
├── Services/
│   ├── FileService.h/.mm
│   ├── SearchService.h/.mm
│   └── PluginService.h/.mm
└── Resources/
    ├── MainMenu.xib
    ├── SyntaxThemes/
    └── Icons/
```

### 关键技术选择
- **UI框架**：Cocoa (Objective-C)
- **文本引擎**：Scintilla (C++)
- **构建系统**：CMake
- **部署目标**：macOS 10.15+

## 开发进度跟踪

当前状态：架构设计完成，准备开始实现第一阶段