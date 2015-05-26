import UIKit
import MobileCoreServices

private let LastCheckedPasteboardVersionKey = "PoppinsLastCheckedPasteboardVersionKey"

private let GIFType = CFBridgingRetain(kUTTypeGIF) as! String
private let JPEGType = CFBridgingRetain(kUTTypeJPEG) as! String
private let PNGType = CFBridgingRetain(kUTTypePNG) as! String

struct Pasteboard {
    static func fetchImageData() -> NSData? {
        let systemPasteboard = UIPasteboard.generalPasteboard()

        let gif = systemPasteboard.dataForPasteboardType(GIFType)
        let jpeg = systemPasteboard.dataForPasteboardType(JPEGType)
        let png = systemPasteboard.dataForPasteboardType(PNGType)

        return gif ?? jpeg ?? png
    }

    static var hasImageData :Bool {
        if !hasPasteboardChanged { return false }

        let systemPasteboard = UIPasteboard.generalPasteboard()
        NSUserDefaults.standardUserDefaults().setInteger(systemPasteboard.changeCount, forKey: LastCheckedPasteboardVersionKey)

        return systemPasteboard.containsPasteboardTypes([GIFType, JPEGType, PNGType])
    }

    private static var hasPasteboardChanged: Bool {
        let lastCheckedVersion = NSUserDefaults.standardUserDefaults().integerForKey(LastCheckedPasteboardVersionKey)
        return lastCheckedVersion != UIPasteboard.generalPasteboard().changeCount
    }
}
