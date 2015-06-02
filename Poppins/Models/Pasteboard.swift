import UIKit
import MobileCoreServices

private let LastCheckedPasteboardVersionKey = "PoppinsLastCheckedPasteboardVersionKey"

let GIFType = CFBridgingRetain(kUTTypeGIF) as! String
let JPEGType = CFBridgingRetain(kUTTypeJPEG) as! String
let PNGType = CFBridgingRetain(kUTTypePNG) as! String

struct Pasteboard {
    static func fetchImageData() -> (data: NSData, type: String)? {
        let systemPasteboard = UIPasteboard.generalPasteboard()

        if let gif = systemPasteboard.dataForPasteboardType(GIFType) { return (gif, GIFType) }
        if let jpeg = systemPasteboard.dataForPasteboardType(JPEGType) { return (jpeg, JPEGType) }
        if let png = systemPasteboard.dataForPasteboardType(PNGType) { return (png, PNGType) }

        return .None
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
