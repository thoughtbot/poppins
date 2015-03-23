import UIKit

struct ApplicationAppearance {
    static func setupAppearance() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBarBackground"), forBarMetrics: .Default)

        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
}
