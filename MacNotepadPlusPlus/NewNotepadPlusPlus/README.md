# Simplepad - 轻量级 macOS 文本编辑器

## 项目简介
Simplepad 是一个简洁、高效的 macOS 文本编辑器，专为需要快速编辑文本文件的用户设计。它采用 Objective-C 和 Cocoa 框架开发，提供了基本的文本编辑功能，具有启动快速、界面简洁、操作流畅的特点。

## 功能特性

### 核心功能
- ✅ **文本编辑**: 基本的文本输入、编辑和显示
- ✅ **文件操作**: 新建、打开、保存文本文件
- ✅ **撤销/重做**: 完整的编辑历史管理
- ✅ **剪切/复制/粘贴**: 标准文本操作
- ✅ **字体设置**: 集成系统字体面板

### 用户界面
- ✅ **简洁界面**: 专注于文本编辑的简洁设计
- ✅ **标准菜单**: 完整的 macOS 应用程序菜单
- ✅ **快捷键支持**: 所有常用操作的键盘快捷键
- ✅ **文档状态跟踪**: 实时显示文档修改状态

### 技术特色
- ✅ **单一文件架构**: 所有核心功能在单一文件中实现
- ✅ **Cocoa 框架**: 使用标准的 macOS 开发框架
- ✅ **ARC 内存管理**: 自动引用计数，避免内存泄漏
- ✅ **CMake 构建**: 跨平台的构建系统配置

## 系统要求

### 最低要求
- **操作系统**: macOS 10.15 或更高版本
- **处理器**: 64位 Intel 或 Apple Silicon 处理器
- **内存**: 4GB RAM
- **存储**: 50MB 可用空间

### 推荐配置
- **操作系统**: macOS 12.0 或更高版本
- **处理器**: Apple Silicon 处理器
- **内存**: 8GB RAM
- **存储**: 100MB 可用空间

## 快速开始

### 下载和安装
1. 从 Releases 页面下载最新版本的 Simplepad.app
2. 将应用程序拖拽到 Applications 文件夹
3. 在 Launchpad 或 Applications 文件夹中启动 Simplepad

### 从源代码构建
```bash
# 克隆项目
cd /Users/harryhua/Documents/GitHub/Demo/MacNotepadPlusPlus/NewNotepadPlusPlus

# 创建构建目录
mkdir build && cd build

# 配置 CMake
cmake ..

# 编译应用程序
make

# 运行应用程序
open Simplepad.app
```

## 使用指南

### 基本操作
1. **新建文件**: 使用 `Cmd+N` 或从文件菜单中选择"新建"
2. **打开文件**: 使用 `Cmd+O` 或从文件菜单中选择"打开"
3. **保存文件**: 使用 `Cmd+S` 或从文件菜单中选择"保存"
4. **文本编辑**: 直接在文本区域输入和编辑文本

### 快捷键参考
| 功能 | 快捷键 | 说明 |
|------|--------|------|
| 新建文件 | Cmd+N | 创建新文档 |
| 打开文件 | Cmd+O | 打开现有文件 |
| 保存文件 | Cmd+S | 保存当前文档 |
| 撤销 | Cmd+Z | 撤销上一步操作 |
| 重做 | Cmd+Shift+Z | 重做撤销的操作 |
| 剪切 | Cmd+X | 剪切选中文本 |
| 复制 | Cmd+C | 复制选中文本 |
| 粘贴 | Cmd+V | 粘贴剪贴板内容 |
| 全选 | Cmd+A | 选择所有文本 |
| 字体设置 | Cmd+T | 打开字体面板 |

### 文件格式支持
- **纯文本文件**: .txt, .text
- **Markdown 文件**: .md
- **编码**: UTF-8

## 开发文档

### 项目结构
```
Simplepad/
├── SimpleTextEditor.m     # 主程序文件
├── CMakeLists.txt         # 构建配置文件
├── Info.plist            # 应用程序配置
├── test_simple_editor.py # 测试脚本
├── 功能实现说明.md        # 功能实现文档
├── 版本更新日志.md        # 版本历史记录
├── 清理报告.md           # 系统清理报告
└── 名称变更对照表.md      # 名称变更记录
```

### 构建说明
项目使用 CMake 作为构建系统，支持以下构建选项：

```bash
# 调试版本
cmake -DCMAKE_BUILD_TYPE=Debug ..

# 发布版本  
cmake -DCMAKE_BUILD_TYPE=Release ..

# 自定义安装路径
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
```

### 测试说明
项目包含完整的自动化测试脚本：

```bash
# 运行所有测试
python3 test_simple_editor.py

# 查看测试报告
cat test_report.txt
```

## 贡献指南

### 报告问题
如果您发现任何问题，请通过以下方式报告：
1. 检查已知问题列表
2. 创建详细的问题报告
3. 提供复现步骤和环境信息

### 功能建议
欢迎提出功能建议：
1. 查看未来版本规划
2. 提交功能需求说明
3. 参与功能设计讨论

### 代码贡献
如果您想贡献代码：
1. Fork 项目仓库
2. 创建功能分支
3. 提交代码更改
4. 创建 Pull Request

## 许可证信息

Simplepad 采用 MIT 许可证发布：

```
MIT License

Copyright (c) 2025 Simplepad

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 联系方式

### 项目维护
- **项目仓库**: [GitHub 仓库地址]
- **问题跟踪**: [GitHub Issues]
- **文档更新**: [GitHub Wiki]

### 技术支持
- **文档参考**: 本项目文档
- **社区支持**: [GitHub Discussions]
- **邮件支持**: [项目维护者邮箱]

## 版本历史

### 版本 1.0.0 (2025-12-26)
- ✅ 初始版本发布
- ✅ 基本文本编辑功能
- ✅ 文件操作功能
- ✅ 完整的菜单系统
- ✅ 文档状态管理
- ✅ 自动化测试体系

### 未来版本规划
- 🔄 语法高亮功能
- 🔄 查找替换功能
- 🔄 多标签页支持
- 🔄 插件系统
- 🔄 主题定制

---

*最后更新: 2025年12月26日*  
*当前版本: 1.0.0*  
*文档版本: 1.0*