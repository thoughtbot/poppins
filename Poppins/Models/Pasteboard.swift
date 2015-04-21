import UIKit
import MobileCoreServices

private let LastCheckedPasteboardVersionKey = "PoppinsLastCheckedPasteboardVersionKey"

struct Pasteboard {
    static func fetchImageData() -> NSData? {
        if !hasPasteboardChanged { return .None }

        let systemPasteboard = UIPasteboard.generalPasteboard()
        NSUserDefaults.standardUserDefaults().setInteger(systemPasteboard.changeCount, forKey: LastCheckedPasteboardVersionKey)

        let gif = systemPasteboard.dataForPasteboardType(CFBridgingRetain(kUTTypeGIF) as! String)
        let jpeg = systemPasteboard.dataForPasteboardType(CFBridgingRetain(kUTTypeJPEG) as! String)
        let png = systemPasteboard.dataForPasteboardType(CFBridgingRetain(kUTTypePNG) as! String)
        return gif ?? jpeg ?? png
    }

    private static var hasPasteboardChanged: Bool {
        let lastCheckedVersion = NSUserDefaults.standardUserDefaults().integerForKey(LastCheckedPasteboardVersionKey)
        return lastCheckedVersion != UIPasteboard.generalPasteboard().changeCount
    }
}
