import AppKit

class SyntaxHighlighter {
    enum Language: String, CaseIterable {
        case plain, swift, cpp, json, python, html, css
    }
    
    struct HighlightRule {
        let regex: NSRegularExpression
        let attributes: [NSAttributedString.Key: Any]
    }
    
    private var rules: [Language: [HighlightRule]] = [:]
    
    init() {
        setupSwiftRules()
        setupCppRules()
        setupJsonRules()
        setupPythonRules()
        setupHTMLRules()
        setupCSSRules()
    }
    
    func highlight(textStorage: NSTextStorage, language: Language) {
        let range = NSRange(location: 0, length: textStorage.length)
        textStorage.removeAttribute(.foregroundColor, range: range)
        textStorage.addAttribute(.foregroundColor, value: NSColor.labelColor, range: range)
        
        guard let languageRules = rules[language] else { return }
        
        for rule in languageRules {
            rule.regex.enumerateMatches(in: textStorage.string, options: [], range: range) { match, _, _ in
                if let matchRange = match?.range {
                    textStorage.addAttributes(rule.attributes, range: matchRange)
                }
            }
        }
    }
    
    // Helper to create rules with less boilerplate
    private func createRule(pattern: String, color: NSColor, options: NSRegularExpression.Options = []) -> HighlightRule {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return HighlightRule(regex: regex, attributes: [.foregroundColor: color])
    }
    
    private func setupSwiftRules() {
        let keywords = "\\b(func|var|let|if|else|switch|case|default|for|while|in|return|struct|class|enum|extension|import|init|self|try|catch|guard|defer|throw)\\b"
        let types = "\\b(Int|String|Double|Float|Bool|Any|Array|Dictionary|Set|Void)\\b"
        
        rules[.swift] = [
            createRule(pattern: keywords, color: .systemPink),
            createRule(pattern: types, color: .systemPurple),
            createRule(pattern: "//.*", color: .systemGray),
            createRule(pattern: "\".*?\"", color: .systemBrown)
        ]
    }
    
    private func setupCppRules() {
        let keywords = "\\b(int|char|long|float|double|bool|void|struct|class|namespace|using|public|private|protected|if|else|for|while|do|switch|case|break|continue|return|new|delete|try|catch|throw|const|static|inline|virtual|override|final|include|define|ifdef|endif)\\b"
        
        rules[.cpp] = [
            createRule(pattern: keywords, color: .systemBlue),
            createRule(pattern: "//.*|/\\*.*?\\*/", color: .systemGray, options: .dotMatchesLineSeparators),
            createRule(pattern: "\".*?\"", color: .systemBrown)
        ]
    }
    
    private func setupJsonRules() {
        rules[.json] = [
            createRule(pattern: "\".*?\"\\s*:", color: .systemBlue),
            createRule(pattern: ":\\s*(\".*?\"|\\d+|true|false|null)", color: .systemOrange)
        ]
    }
    
    private func setupPythonRules() {
        let keywords = "\\b(def|class|if|else|elif|for|while|import|from|as|return|None|True|False|and|or|not|in|is|lambda|with|try|except|finally|pass|break|continue)\\b"
        rules[.python] = [
            createRule(pattern: keywords, color: .systemPink),
            createRule(pattern: "\".*?\"|'.*?'", color: .systemOrange),
            createRule(pattern: "#.*", color: .systemGreen)
        ]
    }
    
    private func setupHTMLRules() {
        rules[.html] = [
            createRule(pattern: "<[^>]+>", color: .systemBlue),
            createRule(pattern: "\".*?\"", color: .systemOrange),
            createRule(pattern: "<!--.*?-->", color: .systemGreen)
        ]
    }
    
    private func setupCSSRules() {
        let props = "\\b(color|background|margin|padding|font-size|display|position|top|left|right|bottom|width|height|border|flex|grid)\\b"
        rules[.css] = [
            createRule(pattern: props, color: .systemIndigo),
            createRule(pattern: "\\.[a-zA-Z0-9_-]+|#[a-zA-Z0-9_-]+", color: .systemPink),
            createRule(pattern: "/\\*.*?\\*/", color: .systemGreen)
        ]
    }
}
