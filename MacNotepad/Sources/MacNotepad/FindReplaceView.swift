import SwiftUI

struct FindReplacePanel: View {
    @ObservedObject var manager: DocumentManager
    @State private var findText: String = ""
    @State private var replaceText: String = ""
    @State private var showReplace: Bool = false
    @State private var searchMode: DocumentManager.SearchMode = .normal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(manager.l10n("find_replace"))
                    .font(.headline)
                Spacer()
                Button(action: { manager.showFindReplace = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(manager.l10n("find"), text: $findText)
                        .textFieldStyle(.roundedBorder)
                        .frame(minWidth: 200)
                    
                    Button(manager.l10n("next")) {
                        manager.findNext(text: findText, mode: searchMode)
                    }
                    .keyboardShortcut(.return, modifiers: [])
                }
                
                if showReplace {
                    HStack {
                        Image(systemName: "arrow.right.arrow.left")
                        TextField(manager.l10n("replace"), text: $replaceText)
                            .textFieldStyle(.roundedBorder)
                            .frame(minWidth: 200)
                        
                        Button(manager.l10n("replace")) {
                            manager.replace(find: findText, replace: replaceText, mode: searchMode, all: false)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button(manager.l10n("replace_all")) {
                            manager.replace(find: findText, replace: replaceText, mode: searchMode, all: true)
                        }
                    }
                }
            }
            
            HStack {
                Picker(manager.l10n("mode"), selection: $searchMode) {
                    Text(manager.l10n("normal")).tag(DocumentManager.SearchMode.normal)
                    Text(manager.l10n("regex")).tag(DocumentManager.SearchMode.regex)
                    Text(manager.l10n("extended")).tag(DocumentManager.SearchMode.extended)
                }
                .pickerStyle(.segmented)
                .frame(width: 180)
                
                Spacer()
                
                Button(showReplace ? manager.l10n("hide_replace") : manager.l10n("show_replace")) {
                    withAnimation {
                        showReplace.toggle()
                    }
                }
                .buttonStyle(.link)
            }
        }
        .padding()
        .frame(width: 350)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

// Helper for blurred background
struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
