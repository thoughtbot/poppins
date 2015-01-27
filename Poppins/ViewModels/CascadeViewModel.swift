import LlamaKit
import Runes

struct CascadeViewModel {
    let manager: SyncManager
    let images: [String]

    var numberOfImages: Int {
        return images.count
    }

    func imagePathForIndexPath(indexPath: NSIndexPath) -> String? {
        return images.safeValue(indexPath.row)
    }

    func imageSizeForIndexPath(indexPath: NSIndexPath) -> CGSize? {
        let path = imagePathForIndexPath(indexPath)
        let data: Result<NSData, NSError> = path.toResult() >>- manager.getFile
        return { $0.size } <^> data.value >>- imageForData
    }

    func gifItemSourceForIndexPath(indexPath: NSIndexPath) -> GifItemSource? {
        let path = imagePathForIndexPath(indexPath)
        let data = path >>- { self.manager.getFile($0).value }
        return GifItemSource.create <^> data
    }
}
