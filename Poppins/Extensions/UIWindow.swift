import UIKit

extension UIWindow {
    class var ApplicationWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.blackColor()
        return window
    }
}
