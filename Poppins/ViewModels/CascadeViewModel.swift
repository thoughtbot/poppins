import LlamaKit
import Runes

struct CascadeViewModel {
    let images: [String]

    var numberOfImages: Int {
        return images.count
    }

    func imagePathForIndexPath(indexPath: NSIndexPath) -> String? {
        return safeValue(images, indexPath.row)
    }

    func imageSizeForIndexPath(indexPath: NSIndexPath) -> CGSize? {
        let path = imagePathForIndexPath(indexPath)
        let data: Result<NSData, NSError> = path.toResult() >>- SyncManager.sharedManager.getFile
        return { $0.size } <^> data.value >>- imageForData
    }

    func gifItemSourceForIndexPath(indexPath: NSIndexPath) -> GifItemSource? {
        let path = imagePathForIndexPath(indexPath)
        let data = path >>- { SyncManager.sharedManager.getFile($0).value }
        return GifItemSource.create <^> data
    }
}
