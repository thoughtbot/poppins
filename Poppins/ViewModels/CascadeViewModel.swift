import LlamaKit
import Runes

struct CascadeViewModel {
    let images: [CachedImage]

    var numberOfImages: Int {
        return images.count
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
}
