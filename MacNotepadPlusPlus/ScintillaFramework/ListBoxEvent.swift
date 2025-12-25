import Foundation

enum ListBoxEventType {
    case selectionChange
    case doubleClick
}

@objc class ListBoxEvent: NSObject {
    let eventType: ListBoxEventType
    
    init(_ eventType: ListBoxEventType) {
        self.eventType = eventType
    }
}