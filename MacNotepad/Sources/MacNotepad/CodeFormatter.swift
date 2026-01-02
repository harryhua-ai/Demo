import Foundation

struct CodeFormatter {
    static func format(text: String, language: SyntaxHighlighter.Language) -> String {
        switch language {
        case .json:
            return formatJSON(text)
        case .swift, .cpp, .python, .css:
            return formatIndentation(text)
        case .html:
            return formatHTML(text)
        default:
            return text
        }
    }
    
    private static func formatJSON(_ text: String) -> String {
        guard let data = text.data(using: .utf8) else { return text }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let formattedData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return String(data: formattedData, encoding: .utf8) ?? text
        } catch {
            return text // Return original if not valid JSON
        }
    }
    
    private static func formatIndentation(_ text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
        var formattedLines: [String] = []
        var currentIndent = 0
        let indentString = "    "
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            if trimmedLine.isEmpty {
                formattedLines.append("")
                continue
            }
            
            // Adjust indent level if the line starts with a closing brace
            if trimmedLine.hasPrefix("}") || trimmedLine.hasPrefix("]") || trimmedLine.hasPrefix(")") {
                currentIndent = max(0, currentIndent - 1)
            }
            
            let indent = String(repeating: indentString, count: currentIndent)
            formattedLines.append(indent + trimmedLine)
            
            // Adjust indent level if the line ends with an opening brace
            if trimmedLine.hasSuffix("{") || trimmedLine.hasSuffix("[") || trimmedLine.hasSuffix("(") {
                currentIndent += 1
            } else {
                // Check if it's a one-line block or contains both { }
                let openCount = trimmedLine.filter { $0 == "{" || $0 == "[" || $0 == "(" }.count
                let closeCount = trimmedLine.filter { $0 == "}" || $0 == "]" || $0 == ")" }.count
                currentIndent += (openCount - closeCount)
                currentIndent = max(0, currentIndent)
            }
        }
        
        return formattedLines.joined(separator: "\n")
    }
    
    private static func formatHTML(_ text: String) -> String {
        // Simple HTML indentation logic
        let lines = text.components(separatedBy: .newlines)
        var formattedLines: [String] = []
        var currentIndent = 0
        let indentString = "    "
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            if trimmedLine.isEmpty {
                formattedLines.append("")
                continue
            }
            
            // Closing tag
            if trimmedLine.hasPrefix("</") {
                currentIndent = max(0, currentIndent - 1)
            }
            
            let indent = String(repeating: indentString, count: currentIndent)
            formattedLines.append(indent + trimmedLine)
            
            // Opening tag (excluding self-closing and closing)
            if trimmedLine.hasPrefix("<") && !trimmedLine.hasPrefix("</") && !trimmedLine.hasSuffix("/>") && !trimmedLine.contains("</") {
                currentIndent += 1
            }
        }
        return formattedLines.joined(separator: "\n")
    }
}
