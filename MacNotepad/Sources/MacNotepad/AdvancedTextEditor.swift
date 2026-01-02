import SwiftUI
import AppKit

struct AdvancedTextEditor: NSViewRepresentable {
    @Binding var text: String
    var fontSize: CGFloat
    var language: SyntaxHighlighter.Language
    var onCursorChange: (Int, Int) -> Void // (line, column)
    
    private let highlighter = SyntaxHighlighter()

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        
        // Setup TextView
        let textView = NSTextView()
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.delegate = context.coordinator
        textView.allowsUndo = true
        textView.font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        textView.autoresizingMask = [.width]
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        
        // Setup Line Numbers (Ruler View)
        scrollView.drawsBackground = true
        scrollView.hasVerticalRuler = true
        scrollView.rulersVisible = true
        
        let lineNumberView = LineNumberRulerView(textView: textView)
        scrollView.verticalRulerView = lineNumberView
        
        scrollView.documentView = textView
        
        DispatchQueue.main.async {
            self.textView = textView
        }
        
        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(Coordinator.handleFind), name: .findRequest, object: nil)
        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(Coordinator.handleReplace), name: .replaceRequest, object: nil)

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        
        if textView.string != text {
            textView.string = text
            highlighter.highlight(textStorage: textView.textStorage!, language: language)
            nsView.verticalRulerView?.needsDisplay = true
        }
        
        if textView.font?.pointSize != fontSize {
            textView.font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
            highlighter.highlight(textStorage: textView.textStorage!, language: language)
            nsView.verticalRulerView?.needsDisplay = true
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Store reference to textView for external commands
    @State private var textView: NSTextView?

    @MainActor
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: AdvancedTextEditor

        init(_ parent: AdvancedTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            parent.highlighter.highlight(textStorage: textView.textStorage!, language: parent.language)
            textView.enclosingScrollView?.verticalRulerView?.needsDisplay = true
        }
        
        @objc func handleFind(_ notification: Notification) {
            guard let textView = parent.textView,
                  let userInfo = notification.userInfo,
                  let text = userInfo["text"] as? String,
                  let mode = userInfo["mode"] as? DocumentManager.SearchMode,
                  !text.isEmpty else { return }
            
            let content = textView.string
            let currentRange = textView.selectedRange()
            let searchStart = currentRange.location + currentRange.length
            
            var foundRange: NSRange?
            
            if mode == .regex {
                if let regex = try? NSRegularExpression(pattern: text, options: []) {
                    let fullRange = NSRange(location: searchStart, length: content.utf16.count - searchStart)
                    foundRange = regex.firstMatch(in: content, options: [], range: fullRange)?.range
                    
                    // Wrap around
                    if foundRange == nil {
                        let wrapRange = NSRange(location: 0, length: searchStart)
                        foundRange = regex.firstMatch(in: content, options: [], range: wrapRange)?.range
                    }
                }
            } else {
                let options: NSString.CompareOptions = (mode == .extended) ? [] : [.literal]
                let processedText = (mode == .extended) ? text.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "\t") : text
                
                let fullRange = NSRange(location: searchStart, length: content.utf16.count - searchStart)
                let range = (content as NSString).range(of: processedText, options: options, range: fullRange)
                
                if range.location != NSNotFound {
                    foundRange = range
                } else {
                    // Wrap around
                    let wrapRange = NSRange(location: 0, length: searchStart)
                    let range = (content as NSString).range(of: processedText, options: options, range: wrapRange)
                    if range.location != NSNotFound {
                        foundRange = range
                    }
                }
            }
            
            if let range = foundRange {
                textView.setSelectedRange(range)
                textView.scrollRangeToVisible(range)
                textView.showFindIndicator(for: range)
            }
        }
        
        @objc func handleReplace(_ notification: Notification) {
            guard let textView = parent.textView,
                  let userInfo = notification.userInfo,
                  let find = userInfo["find"] as? String,
                  let replace = userInfo["replace"] as? String,
                  let mode = userInfo["mode"] as? DocumentManager.SearchMode,
                  let all = userInfo["all"] as? Bool,
                  !find.isEmpty else { return }
            
            let content = textView.string
            let processedReplace = (mode == .extended) ? replace.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "\t") : replace
            
            if all {
                var newContent = ""
                if mode == .regex {
                    if let regex = try? NSRegularExpression(pattern: find, options: []) {
                        newContent = regex.stringByReplacingMatches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count), withTemplate: replace)
                    }
                } else {
                    let processedFind = (mode == .extended) ? find.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "\t") : find
                    newContent = content.replacingOccurrences(of: processedFind, with: processedReplace)
                }
                
                if !newContent.isEmpty {
                    textView.insertText(newContent, replacementRange: NSRange(location: 0, length: content.utf16.count))
                }
            } else {
                // Replace current selection if matches
                let selectedRange = textView.selectedRange()
                if selectedRange.length > 0 {
                    textView.insertText(processedReplace, replacementRange: selectedRange)
                    // Move to next
                    handleFind(notification)
                } else {
                    // Just find first
                    handleFind(notification)
                }
            }
        }
        
        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            let selection = textView.selectedRange()
            let content = textView.string as NSString
            
            // Bracket Matching
            highlightMatchingBracket(in: textView)
            
            let line = content.substring(to: selection.location).components(separatedBy: CharacterSet.newlines).count
            let lineStart = content.lineRange(for: NSRange(location: selection.location, length: 0)).location
            let column = selection.location - lineStart + 1
            
            parent.onCursorChange(line, column)
        }
        
        private func highlightMatchingBracket(in textView: NSTextView) {
            let selection = textView.selectedRange()
            guard selection.length == 0, selection.location > 0 else { return }
            
            let content = textView.string as NSString
            let charPos = selection.location - 1
            let char = content.substring(with: NSRange(location: charPos, length: 1))
            
            let brackets: [String: String] = ["(": ")", "[": "]", "{": "}", ")": "(", "]": "[", "}": "{"]
            guard let partner = brackets[char] else { return }
            
            // Very simple bracket matcher for demo purposes
            // In a real app, this should handle nesting and performance
            let searchForward = ["(", "[", "{"].contains(char)
            var foundPos: Int?
            
            if searchForward {
                for i in (charPos + 1)..<content.length {
                    if content.substring(with: NSRange(location: i, length: 1)) == partner {
                        foundPos = i; break
                    }
                }
            } else {
                for i in (0..<charPos).reversed() {
                    if content.substring(with: NSRange(location: i, length: 1)) == partner {
                        foundPos = i; break
                    }
                }
            }
            
            if let pos = foundPos {
                textView.showFindIndicator(for: NSRange(location: pos, length: 1))
            }
        }
    }
}

class LineNumberRulerView: NSRulerView {
    init(textView: NSTextView) {
        super.init(scrollView: textView.enclosingScrollView, orientation: .verticalRuler)
        self.clientView = textView
        self.ruleThickness = 40
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = clientView as? NSTextView,
              let layoutManager = textView.layoutManager,
              let textContainer = textView.textContainer
        else { return }
        
        let content = textView.string as NSString
        let visibleRect = textView.visibleRect
        let glyphRange = layoutManager.glyphRange(forBoundingRect: visibleRect, in: textContainer)
        let charRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: textView.font?.pointSize ?? 12) * 0.8,
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        
        var lineNumber = 1
        // Calculate starting line number
        let preRange = NSRange(location: 0, length: charRange.location)
        content.enumerateSubstrings(in: preRange, options: [.byLines, .substringNotRequired]) { _, _, _, _ in
            lineNumber += 1
        }
        
        content.enumerateSubstrings(in: charRange, options: .byLines) { _, lineRange, _, _ in
            let rect = layoutManager.lineFragmentUsedRect(forGlyphAt: layoutManager.glyphIndexForCharacter(at: lineRange.location), effectiveRange: nil)
            
            let y = rect.origin.y - visibleRect.origin.y + (rect.height - 14) / 2 + 2 // Fine-tuned alignment
            let label = "\(lineNumber)" as NSString
            let labelSize = label.size(withAttributes: attributes)
            
            label.draw(at: NSPoint(x: self.ruleThickness - labelSize.width - 5, y: y), withAttributes: attributes)
            
            lineNumber += 1
        }
    }
}

extension NSFont {
    static func * (lhs: NSFont, rhs: CGFloat) -> NSFont {
        return NSFont(descriptor: lhs.fontDescriptor, size: lhs.pointSize * rhs) ?? lhs
    }
}
