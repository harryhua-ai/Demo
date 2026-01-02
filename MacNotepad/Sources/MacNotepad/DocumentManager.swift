import SwiftUI
import Combine
import UniformTypeIdentifiers

@MainActor
class NotepadDocument: ObservableObject, Identifiable {
    let id = UUID()
    @Published var text: String
    @Published var filename: String
    var fileURL: URL?

    init(text: String = "", filename: String = "Untitled", fileURL: URL? = nil) {
        self.text = text
        self.filename = filename
        self.fileURL = fileURL
    }
}

@MainActor
class DocumentManager: ObservableObject {
    @Published var documents: [NotepadDocument] = []
    @Published var selectedDocumentID: UUID?
    @Published var fontSize: CGFloat = 13
    @Published var showFindReplace: Bool = false
    @Published var language: AppLanguage = .english {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: "AppLanguage") }
    }

    enum AppLanguage: String, CaseIterable, Identifiable {
        case english = "en"
        case chinese = "zh"
        var id: String { self.rawValue }
        var displayName: String {
            switch self {
            case .english: return "English"
            case .chinese: return "简体中文"
            }
        }
    }

    enum SearchMode {
        case normal, regex, extended
    }

    init() {
        if let langStr = UserDefaults.standard.string(forKey: "AppLanguage"),
           let lang = AppLanguage(rawValue: langStr) {
            self.language = lang
        }
        loadSession()
        if documents.isEmpty {
            addDocument()
        }
    }
    
    private let sessionKey = "MacNotepadSessionTabs"
    
    func saveSession() {
        let urls = documents.compactMap { $0.fileURL?.absoluteString }
        UserDefaults.standard.set(urls, forKey: sessionKey)
    }
    
    func loadSession() {
        guard let urls = UserDefaults.standard.stringArray(forKey: sessionKey) else { return }
        for urlString in urls {
            if let url = URL(string: urlString) {
                do {
                    let text = try String(contentsOf: url, encoding: .utf8)
                    addDocument(text: text, filename: url.lastPathComponent, fileURL: url)
                } catch {
                    print("Failed to restore session file: \(url)")
                }
            }
        }
    }

    func addDocument(text: String = "", filename: String = "Untitled", fileURL: URL? = nil) {
        let newDoc = NotepadDocument(text: text, filename: filename, fileURL: fileURL)
        documents.append(newDoc)
        selectedDocumentID = newDoc.id
        saveSession()
    }

    func closeDocument(id: UUID) {
        if let index = documents.firstIndex(where: { $0.id == id }) {
            documents.remove(at: index)
            if selectedDocumentID == id {
                selectedDocumentID = documents.last?.id
            }
            saveSession()
        }
        if documents.isEmpty {
            addDocument()
        }
    }
    
    func openFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.plainText]
        panel.allowsMultipleSelection = true
        if panel.runModal() == .OK {
            for url in panel.urls {
                do {
                    let text = try String(contentsOf: url, encoding: .utf8)
                    addDocument(text: text, filename: url.lastPathComponent, fileURL: url)
                } catch {
                    print("Failed to open file: \(error)")
                }
            }
        }
    }
    
    func saveSelectedDocument() {
        guard let id = selectedDocumentID,
              let doc = documents.first(where: { $0.id == id }) else { return }
        
        if let url = doc.fileURL {
            try? doc.text.write(to: url, atomically: true, encoding: .utf8)
        } else {
            saveAs(doc: doc)
        }
    }
    
    func saveAllDocuments() {
        for doc in documents {
            if let url = doc.fileURL {
                try? doc.text.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }
    
    func saveSelectedDocumentAs() {
        guard let id = selectedDocumentID,
              let doc = documents.first(where: { $0.id == id }) else { return }
        saveAs(doc: doc)
    }
    
    func saveAs(doc: NotepadDocument) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.plainText]
        panel.nameFieldStringValue = doc.filename
        if panel.runModal() == .OK, let url = panel.url {
            do {
                try doc.text.write(to: url, atomically: true, encoding: .utf8)
                doc.fileURL = url
                doc.filename = url.lastPathComponent
            } catch {
                print("Failed to save file: \(error)")
            }
        }
    }

    // --- Search & Replace Actions ---
    
    func toggleFind() {
        showFindReplace.toggle()
    }
    
    func findNext(text: String, mode: SearchMode) {
        NotificationCenter.default.post(name: .findRequest, object: nil, userInfo: ["text": text, "mode": mode])
    }
    
    func replace(find: String, replace: String, mode: SearchMode, all: Bool) {
        NotificationCenter.default.post(name: .replaceRequest, object: nil, userInfo: ["find": find, "replace": replace, "mode": mode, "all": all])
    }
    
    func advancedReplace(find: String, replace: String, mode: SearchMode, all: Bool) {
        self.replace(find: find, replace: replace, mode: mode, all: all)
    }
    
    // --- Localization Helper ---
    func l10n(_ key: String) -> String {
        let translations: [AppLanguage: [String: String]] = [
            .english: [
                "find_replace": "Find/Replace",
                "find": "Find",
                "replace": "Replace",
                "replace_all": "Replace All",
                "next": "Next",
                "mode": "Mode",
                "normal": "Normal",
                "regex": "Regex",
                "extended": "Extended",
                "show_replace": "Show Replace",
                "hide_replace": "Hide Replace",
                "new_tab": "New Tab",
                "open": "Open...",
                "save": "Save",
                "save_all": "Save All",
                "save_as": "Save As...",
                "close_tab": "Close Tab",
                "edit_tools": "Edit Tools",
                "convert_case": "Convert Case",
                "line_ops": "Line Operations",
                "conversions": "Conversions",
                "view": "View",
                "search": "Search",
                "zoom_in": "Zoom In",
                "zoom_out": "Zoom Out",
                "font_size": "Font Size",
                "language": "Language"
            ],
            .chinese: [
                "find_replace": "查找/替换",
                "find": "查找内容",
                "replace": "替换为",
                "replace_all": "全部替换",
                "next": "下一个",
                "mode": "模式",
                "normal": "普通",
                "regex": "正则",
                "extended": "扩展",
                "show_replace": "显示替换",
                "hide_replace": "隐藏替换",
                "new_tab": "新建标签页",
                "open": "打开...",
                "save": "保存",
                "save_all": "全部保存",
                "save_as": "另存为...",
                "close_tab": "关闭标签页",
                "edit_tools": "编辑工具",
                "convert_case": "大小写转换",
                "line_ops": "行操作",
                "conversions": "转换工具",
                "view": "视图",
                "search": "搜索",
                "zoom_in": "放大",
                "zoom_out": "缩小",
                "font_size": "字号",
                "language": "语言"
            ]
        ]
        return translations[language]?[key] ?? key
    }

    // --- Professional Text Tools ---
    
    func transformSelected(transformer: (String) -> String) {
        guard let id = selectedDocumentID,
              let doc = documents.first(where: { $0.id == id }) else { return }
        doc.text = transformer(doc.text)
    }
    
    func toUppercase() { transformSelected { $0.uppercased() } }
    func toLowercase() { transformSelected { $0.lowercased() } }
    func toTitleCase() { transformSelected { $0.capitalized } }
    
    func trimTrailingSpaces() {
        transformSelected { text in
            text.components(separatedBy: .newlines)
                .map { $0.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression) }
                .joined(separator: "\n")
        }
    }
    
    func removeEmptyLines() {
        transformSelected { text in
            text.components(separatedBy: .newlines)
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                .joined(separator: "\n")
        }
    }
    
    func sortLinesAscending() {
        transformSelected { text in
            text.components(separatedBy: .newlines).sorted().joined(separator: "\n")
        }
    }
    
    func reverseLines() {
        transformSelected { text in
            text.components(separatedBy: .newlines).reversed().joined(separator: "\n")
        }
    }

    func formatCurrentDocument(language: SyntaxHighlighter.Language) {
        guard let id = selectedDocumentID,
              let doc = documents.first(where: { $0.id == id }) else { return }
        doc.text = CodeFormatter.format(text: doc.text, language: language)
    }

    // --- Conversions ---
    func base64Encode() { transformSelected { Data($0.utf8).base64EncodedString() } }
    func base64Decode() { transformSelected { 
        guard let data = Data(base64Encoded: $0) else { return $0 }
        return String(data: data, encoding: .utf8) ?? $0
    } }
    func urlEncode() { transformSelected { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0 } }
    func urlDecode() { transformSelected { $0.removingPercentEncoding ?? $0 } }
    func textToHex() { transformSelected { $0.utf8.map { String(format: "%02hhx", $0) }.joined(separator: " ") } }
    
    func convertToCRLF() { transformSelected { $0.replacingOccurrences(of: "\n", with: "\r\n") } }
    func convertToLF() { transformSelected { $0.replacingOccurrences(of: "\r\n", with: "\n") } }
    func convertToGBK() {
        transformSelected { text in
            let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            guard let data = text.data(using: String.Encoding(rawValue: encoding)) else { return text }
            return String(data: data, encoding: String.Encoding(rawValue: encoding)) ?? text
        }
    }

    // --- UI Actions ---
    func zoomIn() { fontSize += 1 }
    func zoomOut() { fontSize = max(8, fontSize - 1) }
}

extension NSNotification.Name {
    static let findRequest = NSNotification.Name("findRequest")
    static let replaceRequest = NSNotification.Name("replaceRequest")
}
