import Foundation

@objc protocol IListBoxDelegate {
    func listNotify(_ event: ListBoxEvent)
}