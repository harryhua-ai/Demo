cmake_minimum_required(VERSION 3.20)
project(Simplepad)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 设置 macOS 部署目标
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum OS X deployment version")

# 启用 Objective-C 和 Objective-C++ 支持
enable_language(OBJC)
enable_language(OBJCXX)

# 设置编译选项
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")
set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -fobjc-arc")

# 查找所需的框架
find_library(COCOA_FRAMEWORK Cocoa)
find_library(APPKIT_FRAMEWORK AppKit)
find_library(FOUNDATION_FRAMEWORK Foundation)

# 包含目录
include_directories(
    .
    ../notepad-plus-plus/PowerEditor/src  # 包含原始项目的头文件
    ../notepad-plus-plus/scintilla/include
    ../notepad-plus-plus/scintilla/src
    ../notepad-plus-plus/lexilla/include
    ../notepad-plus-plus/lexilla/lexlib
)

# 查找所有源文件
file(GLOB SOURCES 
    "*.m" 
)

# 确保所有源文件都被包含
message(STATUS "找到的源文件: ${SOURCES}")

# 创建应用程序 bundle
add_executable(Simplepad MACOSX_BUNDLE 
    SimpleTextEditor.m
)

# 链接框架
target_link_libraries(Simplepad 
    ${COCOA_FRAMEWORK}
    ${APPKIT_FRAMEWORK}
    ${FOUNDATION_FRAMEWORK}
)

# 设置应用程序属性
set_target_properties(Simplepad PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
    MACOSX_BUNDLE_GUI_IDENTIFIER com.simplepad.Simplepad
    MACOSX_BUNDLE_BUNDLE_NAME "Simplepad"
    MACOSX_BUNDLE_BUNDLE_VERSION "1.0"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0"
    OUTPUT_NAME "Simplepad"
)

