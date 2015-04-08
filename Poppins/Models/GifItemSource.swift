import MobileCoreServices

class GifItemSource: NSObject, UIActivityItemSource {
    let imageData: NSData

    init(data: NSData) {
        imageData = data
        super.init()
    }

    class func create(data: NSData) -> GifItemSource {
        return GifItemSource(data: data)
    }

    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return imageData
    }

    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        return imageData
    }

    func activityViewController(activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: String?) -> String {
        return CFBridgingRetain(kUTTypeGIF) as! String
    }
}
