cmake_minimum_required(VERSION 3.20)
project(NotepadPlusPlus)

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

# Scintilla source files
file(GLOB SCINTILLA_SOURCES 
    "../scintilla/src/*.cxx"
    "../scintilla/cocoa/*.mm"
    "../scintilla/cocoa/*.m"
)

# 排除特定的源文件
list(FILTER SCINTILLA_SOURCES EXCLUDE REGEX "ScintillaDLL.cxx")

# Lexilla source files
file(GLOB LEXILLA_SOURCES 
    "../lexilla/src/*.cxx"
    "../lexilla/lexlib/*.cxx"
    "../lexilla/lexers/*.cxx"
)

# 排除特定的源文件
list(FILTER LEXILLA_SOURCES EXCLUDE REGEX "LexUser.cxx")

# 包含目录
include_directories(
    NotepadPlusPlus
    ../scintilla/include
    ../scintilla/src
    ../scintilla/cocoa
    ../lexilla/include
    ../lexilla/lexlib
)

# 查找所有源文件
file(GLOB_RECURSE SOURCES 
    "NotepadPlusPlus/*.mm" 
    "NotepadPlusPlus/*.m" 
    "NotepadPlusPlus/*.cpp" 
    "NotepadPlusPlus/*.c"
)

# 排除特定的源文件
list(FILTER SOURCES EXCLUDE REGEX "LexUser.cxx")

# 创建应用程序 bundle
add_executable(NotepadPlusPlus MACOSX_BUNDLE 
    ${SOURCES} 
    ${SCINTILLA_SOURCES}
    ${LEXILLA_SOURCES}
)

# 设置应用程序属性
set_target_properties(NotepadPlusPlus PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/NotepadPlusPlus/Info.plist
    MACOSX_BUNDLE_GUI_IDENTIFIER com.notepadplusplus.NotepadPlusPlus
    MACOSX_BUNDLE_BUNDLE_NAME "Notepad++"
    MACOSX_BUNDLE_BUNDLE_VERSION "1.0"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0"
    OUTPUT_NAME "Notepad++"
)

# 链接库
target_link_libraries(NotepadPlusPlus 
    ${COCOA_FRAMEWORK}
    ${APPKIT_FRAMEWORK}
    ${FOUNDATION_FRAMEWORK}
)

# 复制非本地化资源文件
set(RESOURCE_FILES
    NotepadPlusPlus/Resources/MainMenu.xib
)

# 复制资源到 bundle
foreach(RESOURCE_FILE ${RESOURCE_FILES})
    get_filename_component(RESOURCE_NAME ${RESOURCE_FILE} NAME)
    add_custom_command(TARGET NotepadPlusPlus POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/${RESOURCE_FILE}
        $<TARGET_FILE_DIR:NotepadPlusPlus>/../Resources/${RESOURCE_NAME})
endforeach()

# 复制本地化资源
set(LOCALIZATION_DIRS
    NotepadPlusPlus/Resources/en.lproj
    NotepadPlusPlus/Resources/zh-Hans.lproj
)

foreach(LOCALIZATION_DIR ${LOCALIZATION_DIRS})
    get_filename_component(LANG_NAME ${LOCALIZATION_DIR} NAME)
    file(GLOB LOCALIZATION_FILES "${LOCALIZATION_DIR}/*")
    foreach(LOCALIZATION_FILE ${LOCALIZATION_FILES})
        get_filename_component(FILE_NAME ${LOCALIZATION_FILE} NAME)
        add_custom_command(TARGET NotepadPlusPlus POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory
            $<TARGET_FILE_DIR:NotepadPlusPlus>/../Resources/${LANG_NAME})
        add_custom_command(TARGET NotepadPlusPlus POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${CMAKE_CURRENT_SOURCE_DIR}/${LOCALIZATION_FILE}
            $<TARGET_FILE_DIR:NotepadPlusPlus>/../Resources/${LANG_NAME}/${FILE_NAME})
    endforeach()
endforeach()