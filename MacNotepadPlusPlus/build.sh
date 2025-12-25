#!/bin/bash

# 构建或清理 Notepad++ for macOS
# 用法: ./build.sh [build|clean|rebuild]

ACTION=${1:-build}
CORES=${2:-0}

# 获取CPU核心数的跨平台方法
if [ "$CORES" -eq 0 ]; then
    if command -v nproc > /dev/null 2>&1; then
        CORES=$(nproc)
    elif command -v sysctl > /dev/null 2>&1; then
        CORES=$(sysctl -n hw.ncpu)
    else
        CORES=1
    fi
fi

case $ACTION in
    clean)
        echo "清理编译的临时文件..."
        if [ -d "build" ]; then
            rm -rf build
            echo "已清理构建目录。"
        else
            echo "构建目录不存在，无需清理。"
        fi
        ;;
    build)
        echo "创建构建目录"
        mkdir -p build
        cd build

        # 运行 cmake 配置
        cmake .. -DCMAKE_BUILD_TYPE=Release

        # 构建项目
        make -j$CORES

        # 返回上级目录
        cd ..
        echo "构建完成！应用程序位于 build/NotepadPlusPlus.app"
        ;;
    rebuild)
        echo "重新构建项目..."
        $0 clean
        $0 build $CORES
        ;;
    *)
        echo "用法: $0 [build|clean|rebuild] [core_count]"
        echo "  build (默认) - 构建项目"
        echo "  clean - 清理所有编译的临时文件"
        echo "  rebuild - 清理后重新构建"
        echo "  core_count - 指定并行构建的CPU核心数，默认自动检测"
        ;;
esac