import SwiftUI

@main
struct MacNotepadApp: App {
    @StateObject private var manager = DocumentManager()

    var body: some Scene {
        WindowGroup {
            ContentView(manager: manager)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button(manager.l10n("new_tab")) {
                    manager.addDocument()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            CommandGroup(replacing: .saveItem) {
                Button(manager.l10n("save")) {
                    manager.saveSelectedDocument()
                }
                .keyboardShortcut("s", modifiers: .command)
                
                Button(manager.l10n("save_all")) {
                    manager.saveAllDocuments()
                }
                .keyboardShortcut("s", modifiers: [.command, .option])
                
                Button(manager.l10n("open")) {
                    manager.openFile()
                }
                .keyboardShortcut("o", modifiers: .command)
                
                Button(manager.l10n("save_as")) {
                    manager.saveSelectedDocumentAs()
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])
                
                Button(manager.l10n("close_tab")) {
                    if let id = manager.selectedDocumentID {
                        manager.closeDocument(id: id)
                    }
                }
                .keyboardShortcut("w", modifiers: .command)
            }
            
            CommandMenu(manager.l10n("edit_tools")) {
                Menu(manager.l10n("convert_case")) {
                    Button("UPPERCASE") { manager.toUppercase() }
                    Button("lowercase") { manager.toLowercase() }
                    Button("Title Case") { manager.toTitleCase() }
                }
                
                Divider()
                
                Menu(manager.l10n("line_ops")) {
                    Button(manager.language == .chinese ? "升序排列" : "Sort Lines Ascending") { manager.sortLinesAscending() }
                    Button(manager.language == .chinese ? "反转行" : "Reverse Lines") { manager.reverseLines() }
                    Button(manager.language == .chinese ? "移除空行" : "Remove Empty Lines") { manager.removeEmptyLines() }
                }
                
                Divider()
                
                Button(manager.language == .chinese ? "删除行尾空格" : "Trim Trailing Spaces") { manager.trimTrailingSpaces() }
                
                Divider()
                
                Menu(manager.l10n("conversions")) {
                    Button("Base64 Encode") { manager.base64Encode() }
                    Button("Base64 Decode") { manager.base64Decode() }
                    Divider()
                    Button("URL Encode") { manager.urlEncode() }
                    Button("URL Decode") { manager.urlDecode() }
                    Divider()
                    Button("Text to Hex") { manager.textToHex() }
                    Divider()
                    Menu(manager.language == .chinese ? "换行符" : "Line Endings") {
                        Button("to Windows (CRLF)") { manager.convertToCRLF() }
                        Button("to Unix (LF)") { manager.convertToLF() }
                    }
                    Menu(manager.language == .chinese ? "编码" : "Encoding") {
                        Button("Convert to GBK (Windows)") { manager.convertToGBK() }
                    }
                }
            }
            
            CommandMenu(manager.l10n("view")) {
                Button(manager.l10n("zoom_in")) { manager.zoomIn() }
                    .keyboardShortcut("+", modifiers: .command)
                Button(manager.l10n("zoom_out")) { manager.zoomOut() }
                    .keyboardShortcut("-", modifiers: .command)
                
                Divider()
                
                Menu(manager.l10n("language")) {
                    ForEach(DocumentManager.AppLanguage.allCases) { lang in
                        Button(action: { manager.language = lang }) {
                            HStack {
                                Text(lang.displayName)
                                if manager.language == lang {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            CommandMenu(manager.l10n("search")) {
                Button(manager.l10n("find")) {
                    manager.toggleFind()
                }
                .keyboardShortcut("f", modifiers: .command)
            }
        }
    }
}
