import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow.ApplicationWindow
    var controller = ApplicationController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        if application.isUnitTesting() {
            return true
        }

        controller.configureLinkedService()

        window?.rootViewController = controller.rootViewController
        window?.makeKeyAndVisible()
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return controller.handleExternalURL(url)
    }
}
