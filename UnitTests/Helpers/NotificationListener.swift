@objc public class NotificationListener {
    var fired: Bool = false

    init(notificationName: String) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handler", name: notificationName, object: .None)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    public func handler() {
        fired = true
    }
}
