import UIKit

class FacebookMessengerActivity: UIActivity {
    var data: NSData?

    override class func activityCategory() -> UIActivityCategory {
        return .Share
    }

    override func activityType() -> String? {
        return "ActivityTypePostToFacebookMessenger"
    }

    override func activityTitle() -> String? {
        return NSLocalizedString("Send to Facebook Messenger", comment: "fb messenger share message")
    }

    override func activityImage() -> UIImage? {
        return UIImage(named: "MessengerIcon")
    }

    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }

    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        data = activityItems.first as? NSData
    }

    override func performActivity() {
        let gifOptionValue = FBSDKMessengerPlatformCapability.AnimatedGIF.rawValue
        if FBSDKMessengerSharer.messengerPlatformCapabilities().rawValue & gifOptionValue == gifOptionValue {
            if let data = data {
                FBSDKMessengerSharer.shareAnimatedGIF(data, withOptions: nil)
                activityDidFinish(true)
                return
            }
        }
        activityDidFinish(false)
    }
}
