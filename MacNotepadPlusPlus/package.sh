#!/bin/bash

# 将 Notepad++ 打包为 DMG 文件

APP_NAME="NotepadPlusPlus"
DMG_NAME="NotepadPlusPlus.dmg"
TEMP_DIR="./dmg"

# 构建项目
./build.sh

# 创建临时目录
mkdir -p "${TEMP_DIR}"

# 拷贝应用程序到临时目录
cp -R "build/${APP_NAME}.app" "${TEMP_DIR}/"

# 创建软链接到 Applications 文件夹
ln -s /Applications "${TEMP_DIR}/Applications"

# 创建 DMG
hdiutil create -volname "${APP_NAME}" \
               -srcfolder "${TEMP_DIR}" \
               -ov \
               -format UDZO "${DMG_NAME}"

# 清理临时目录
rm -rf "${TEMP_DIR}"

echo "打包完成！DMG 文件: ${DMG_NAME}"