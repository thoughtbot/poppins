import Foundation
import Gifu
import Runes

class ImageFetcher {
    let imageCache: Cache<[AnimatedFrame]>
    let purger: CachePurger
    let operationQueue: AsyncQueue
    let manager: SyncManager
    var operations: [String: NSOperation] = [:]

    init(manager: SyncManager) {
        imageCache = Cache<[AnimatedFrame]>()
        purger = CachePurger(cache: imageCache)
        operationQueue = AsyncQueue(name: "PoppinsCacheQueue", maxOperations: 10)
        self.manager = manager
    }

    func fetchImage(size: CGSize, path: String, callback: [AnimatedFrame] -> ()) {
        if let image = imageCache.itemForKey(path) {
            callback(image)
        } else {
            let operation = ImageFetchOperation(size: size, path: path, manager: manager) {
                self.purger.thumbsUpGoodJob()
                curry(self.imageCache.setItem) <^> $0 <*> path
                self.operations.removeValueForKey(path)
                callback($0)
            }
            operationQueue.addOperation(operation)
            operations[path] = operation
        }
    }

    func cancelFetchForImageAtPath(path: String) {
        operations[path]?.cancel()
        operations.removeValueForKey(path)
    }
}
