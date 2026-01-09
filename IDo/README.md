# IDo - 清新待办

<p align="center">
  <img src="./resources/icon.png" width="100" alt="IDo Logo">
</p>

IDo 是一款清新、极简且高性能的跨平台待办事项管理应用。基于 Electron 和 React 构建，致力于提供毫秒级的丝滑体验，让任务管理回归纯粹。

![alt text](./resources/image.png)
![alt text](./resources/image-1.png)

## ✨ 核心特性

- **极致性能**: 采用 SQLite WAL 模式与 React 组件级记忆化优化，轻松承载万级任务量，操作无卡顿。
- **视觉美学**: 像素级对齐 (70px) 的 UI 设计，配以治愈的“天空蓝” (#00bfff) 主题色与流畅动效。
- **日历视图**: 内置农历显示的日历概览，支持直观的月份切换与任务预览。
- **全能管理**:
  - 多级优先级 (P1-P4) 标签体系
  - 任务/子任务拆解与进度追踪
  - 智能清单：今日待办、最近任务、待办箱
  - 完善的回收站机制（软删除/恢复）
- **全平台支持**: 完美支持 macOS、Windows 和 Linux。

## � 安装包下载

编译后的安装程序位于 `dist` 目录下，您可以直接运行：

- **macOS (Apple Silicon)**: `dist/IDo-1.0.0-arm64.dmg`
- **Windows**: `dist/IDo Setup 1.0.0.exe`
- **Linux**: `dist/ido_1.0.0_arm64.deb`

## �🛠 技术栈

- **核心框架**: Electron, React 19
- **状态管理**: Zustand
- **本地数据库**: better-sqlite3 (Native SQLite)
- **UI/交互**: Framer Motion, Lucide React
- **构建工具**: Electron Vite, Electron Builder

## 🚀 快速开始

### 环境要求

- Node.js (v18 或更高版本)
- npm 或 pnpm

### 开发运行

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### 打包构建

```bash
# 为所有平台构建安装包
npm run build
npm run dist -- --mwl
```

## 📄 许可证

ISC
