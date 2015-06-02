import Result
import Runes

struct CascadeViewModel {
    let images: [CachedImage]

    var numberOfImages: Int {
        return images.count
    }

    var shouldShowEmptyState: Bool {
        return numberOfImages == 0
    }

    func imagePathForIndexPath(indexPath: NSIndexPath) -> String? {
        return images.safeValue(indexPath.row)?.documentDirectoryPath
    }

    func imageSizeForIndexPath(indexPath: NSIndexPath) -> CGSize? {
        let cachedImage = images.safeValue(indexPath.row)
        return CGSize(width: 1, height: cachedImage?.aspectRatio ?? 1)
    }

    func gifItemSourceForIndexPath(indexPath: NSIndexPath) -> GifItemSource? {
        let path = imagePathForIndexPath(indexPath)
        let data = path >>- { NSData(contentsOfFile: $0) }
        return GifItemSource.create <^> data <*> shareURLForIndexPath(indexPath)
    }

    func shareURLForIndexPath(indexPath: NSIndexPath) -> NSURL? {
        let cachedImage = images.safeValue(indexPath.row)
        return cachedImage?.shareURLPath >>- { NSURL(string: "\($0)&raw=1") }
    }

    func alertControllerForImportingPasteboardImage(importCallback: () -> ()) -> UIAlertController {
        let title = NSLocalizedString("New Image Found!", comment: "")
        let message = NSLocalizedString("Would you like to save the image in your pasteboard?", comment: "")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: .None)
        let positiveAction = UIAlertAction(title: "Yes", style: .Default) { _ in
            importCallback()
        }

        alert.addAction(positiveAction)
        alert.addAction(cancelAction)
        return alert
    }
}
