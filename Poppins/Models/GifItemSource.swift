import MobileCoreServices

class GifItemSource: NSObject, UIActivityItemSource {
    let imageData: NSData
    let url: NSURL?

    init(data: NSData, url: NSURL?) {
        imageData = data
        self.url = url
        super.init()
    }

    class func create(data: NSData)(url: NSURL?) -> GifItemSource {
        return GifItemSource(data: data, url: url)
    }

    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return url ?? imageData
    }

    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        switch activityType {
        case UIActivityTypeCopyToPasteboard, UIActivityTypePostToTwitter: return url
        default: return imageData
        }
    }

    func activityViewController(activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: String?) -> String {
        switch activityType ?? "" {
        case UIActivityTypeCopyToPasteboard, UIActivityTypePostToTwitter: return CFBridgingRetain(kUTTypeURL) as! String
        default: return CFBridgingRetain(kUTTypeGIF) as! String
        }
    }
}
