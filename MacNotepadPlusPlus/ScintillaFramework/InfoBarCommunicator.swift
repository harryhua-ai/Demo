import Foundation

@objc protocol InfoBarCommunicator {
    func notify(newStatus: Int)
    func notify(newStatus: Int, message: String)
    func notify(message: String)
    func listNotify(_ event: ListBoxEvent)
}