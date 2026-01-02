import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: DocumentManager
    @State private var findText: String = ""
    @State private var replaceText: String = ""
    @State private var cursorPosition: (line: Int, col: Int) = (1, 1)
    @State private var searchMode: DocumentManager.SearchMode = .normal
    @State private var language: SyntaxHighlighter.Language = .plain

    var body: some View {
        VStack(spacing: 0) {
            // Tab Bar
            HStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 2) {
                        ForEach(manager.documents) { doc in
                            TabItem(doc: doc, isSelected: manager.selectedDocumentID == doc.id) {
                                manager.selectedDocumentID = doc.id
                            } onClose: {
                                manager.closeDocument(id: doc.id)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
                
                Button(action: { manager.addDocument() }) {
                    Image(systemName: "plus")
                        .padding(8)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 30)
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()

            Divider()

            ZStack {
                if let selectedID = manager.selectedDocumentID,
                   let doc = manager.documents.first(where: { $0.id == selectedID }) {
                    AdvancedTextEditor(
                        text: Binding(
                            get: { doc.text },
                            set: { doc.text = $0 }
                        ),
                        fontSize: manager.fontSize,
                        language: language,
                        onCursorChange: { line, col in
                            cursorPosition = (line, col)
                        }
                    )
                } else {
                    Text("No document open")
                        .foregroundColor(.secondary)
                }
                
                if manager.showFindReplace {
                    VStack {
                        HStack {
                            Spacer()
                            FindReplacePanel(manager: manager)
                                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                        }
                        Spacer()
                    }
                    .padding()
                    .zIndex(10)
                }
            }
            
            Divider()
            
            // Status Bar
            statusBar
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 8) {
                    // 1. 新建
                    Button(action: { manager.addDocument() }) {
                        Image(systemName: "plus")
                    }
                    .help("New Tab (Cmd+N)")

                    // 2. 打开
                    Button(action: { manager.openFile() }) {
                        Image(systemName: "doc.badge.plus")
                    }
                    .help("Open File (Cmd+O)")

                    // 3. 保存
                    Button(action: { manager.saveSelectedDocument() }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .help("Save Current (Cmd+S)")

                    // 4. 全部保存
                    Button(action: { manager.saveAllDocuments() }) {
                        Image(systemName: "square.and.arrow.down.on.square")
                    }
                    .help("Save All")

                    Divider().frame(height: 16)

                    // 5. 剪切
                    Button(action: { NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: nil) }) {
                        Image(systemName: "scissors")
                    }
                    .help("Cut (Cmd+X)")

                    // 6. 复制
                    Button(action: { NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: nil) }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .help("Copy (Cmd+C)")

                    // 7. 粘贴
                    Button(action: { NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: nil) }) {
                        Image(systemName: "doc.on.clipboard")
                    }
                    .help("Paste (Cmd+V)")

                    Divider().frame(height: 16)

                    // 8. 后退一步
                    Button(action: { NSApp.sendAction(#selector(UndoManager.undo), to: nil, from: nil) }) {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .help("Undo (Cmd+Z)")

                    // 9. 前进一步
                    Button(action: { NSApp.sendAction(#selector(UndoManager.redo), to: nil, from: nil) }) {
                        Image(systemName: "arrow.uturn.forward")
                    }
                    .help("Redo (Cmd+Shift+Z)")

                    Divider().frame(height: 16)

                    // 10. 查找
                    Button(action: {
                        withAnimation {
                            manager.toggleFind()
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .help("Toggle Find (Cmd+F)")

                    Divider().frame(height: 16)

                    // 11. 放大
                    Button(action: { manager.zoomIn() }) {
                        Image(systemName: "plus.magnifyingglass")
                    }
                    .help("Zoom In (Cmd++)")

                    // 12. 缩小
                    Button(action: { manager.zoomOut() }) {
                        Image(systemName: "minus.magnifyingglass")
                    }
                    .help("Zoom Out (Cmd+-)")

                    Divider().frame(height: 16)

                    // 13. 编程语言支持
                    Picker("", selection: $language) {
                        Text("Plain").tag(SyntaxHighlighter.Language.plain)
                        Text("Swift").tag(SyntaxHighlighter.Language.swift)
                        Text("C++").tag(SyntaxHighlighter.Language.cpp)
                        Text("JSON").tag(SyntaxHighlighter.Language.json)
                        Text("Python").tag(SyntaxHighlighter.Language.python)
                        Text("HTML").tag(SyntaxHighlighter.Language.html)
                        Text("CSS").tag(SyntaxHighlighter.Language.css)
                    }
                    .frame(width: 80)

                    // 14. 代码格式化
                    Button(action: {
                        manager.formatCurrentDocument(language: language)
                    }) {
                        Image(systemName: "sparkles")
                    }
                    .help("Format Code")
                }
            }
        }
        .frame(minWidth: 700, minHeight: 500)
    }

    private var statusBar: some View {
        HStack {
            Text("Line: \(cursorPosition.line), Col: \(cursorPosition.col)")
            Spacer()
            if let selectedID = manager.selectedDocumentID,
               let doc = manager.documents.first(where: { $0.id == selectedID }) {
                Text("Characters: \(doc.text.count)")
                Divider().frame(height: 12)
                Text("UTF-8")
                Divider().frame(height: 12)
                Text("Unix (LF)")
            }
        }
        .font(.system(size: 11))
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color(NSColor.windowBackgroundColor))
    }

    private var findReplaceBar: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    TextField("Find", text: $findText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    
                    Picker("", selection: $searchMode) {
                        Text("Normal").tag(DocumentManager.SearchMode.normal)
                        Text("Regex").tag(DocumentManager.SearchMode.regex)
                        Text("Extended").tag(DocumentManager.SearchMode.extended)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 180)
                    
                    Button("Next") {
                        findNext()
                    }
                }
                
                HStack {
                    TextField("Replace", text: $replaceText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    
                    Button("Replace") {
                        manager.advancedReplace(find: findText, replace: replaceText, mode: searchMode, all: false)
                    }
                    
                    Button("All") {
                        manager.advancedReplace(find: findText, replace: replaceText, mode: searchMode, all: true)
                    }
                }
            }
            .padding(8)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .shadow(radius: 2)
            
            Spacer()
            
            Button {
                withAnimation {
                    manager.showFindReplace = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 8)
        }
        .padding(8)
        .background(Color(NSColor.windowBackgroundColor))
        .background(Divider(), alignment: .bottom)
    }

    private func findNext() {
        guard !findText.isEmpty else { return }
        // Simple console notification for now as SwiftUI TextEditor doesn't support selection easily
        print("Finding: \(findText)")
    }

    private func replaceAll() {
        manager.advancedReplace(find: findText, replace: replaceText, mode: searchMode, all: true)
    }
}

struct TabItem: View {
    @ObservedObject var doc: NotepadDocument
    var isSelected: Bool
    var onSelect: () -> Void
    var onClose: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(doc.filename)
                .font(.system(size: 12))
                .lineLimit(1)
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
            }
            .buttonStyle(.plain)
            .opacity(isSelected ? 0.7 : 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isSelected ? Color(NSColor.controlAccentColor).opacity(0.1) : Color.clear)
        .background(isSelected ? Color(NSColor.windowBackgroundColor) : Color.clear)
        .cornerRadius(6, corners: [.topLeft, .topRight])
        .onTapGesture(perform: onSelect)
        .overlay(
            Rectangle()
                .frame(height: 2)
                .foregroundColor(isSelected ? Color(NSColor.controlAccentColor) : Color.clear),
            alignment: .bottom
        )
    }
}

struct TextEditorView: View {
    @Binding var text: String
    var body: some View {
        TextEditor(text: $text)
            .font(.system(.body, design: .monospaced))
            .padding(4)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: RectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = NSBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadius: radius)
        return Path(path.cgPath)
    }
}

struct RectCorner: OptionSet {
    let rawValue: Int
    static let topLeft = RectCorner(rawValue: 1 << 0)
    static let topRight = RectCorner(rawValue: 1 << 1)
    static let bottomLeft = RectCorner(rawValue: 1 << 2)
    static let bottomRight = RectCorner(rawValue: 1 << 3)
    static let allCorners: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

extension NSBezierPath {
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< elementCount {
            let type = element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo, .cubicCurveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .quadraticCurveTo:
                path.addQuadCurve(to: points[1], control: points[0])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }
        return path
    }

    convenience init(roundedRect rect: CGRect, byRoundingCorners corners: RectCorner, cornerRadius: CGFloat) {
        self.init()
        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if corners.contains(.topLeft) {
            path.move(to: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y))
        } else {
            path.move(to: topLeft)
        }

        if corners.contains(.topRight) {
            path.addLine(to: CGPoint(x: topRight.x - cornerRadius, y: topRight.y))
            path.addArc(tangent1End: topRight, tangent2End: CGPoint(x: topRight.x, y: topRight.y + cornerRadius), radius: cornerRadius)
        } else {
            path.addLine(to: topRight)
        }

        if corners.contains(.bottomRight) {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerRadius))
            path.addArc(tangent1End: bottomRight, tangent2End: CGPoint(x: bottomRight.x - cornerRadius, y: bottomRight.y), radius: cornerRadius)
        } else {
            path.addLine(to: bottomRight)
        }

        if corners.contains(.bottomLeft) {
            path.addLine(to: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y))
            path.addArc(tangent1End: bottomLeft, tangent2End: CGPoint(x: bottomLeft.x, y: bottomLeft.y - cornerRadius), radius: cornerRadius)
        } else {
            path.addLine(to: bottomLeft)
        }

        if corners.contains(.topLeft) {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerRadius))
            path.addArc(tangent1End: topLeft, tangent2End: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y), radius: cornerRadius)
        } else {
            path.addLine(to: topLeft)
        }

        path.closeSubpath()
        self.append(NSBezierPath(cgPath: path))
    }
}
