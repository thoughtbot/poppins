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

        guard let data = data
            where FBSDKMessengerSharer.messengerPlatformCapabilities().rawValue & gifOptionValue == gifOptionValue
            else { return activityDidFinish(false) }

        FBSDKMessengerSharer.shareAnimatedGIF(data, withOptions: nil)
        activityDidFinish(true)
    }
}
