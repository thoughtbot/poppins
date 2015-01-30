import Foundation
import Runes

class ImageFetcher {
    let imageCache: Cache<UIImage>
    let purger: CachePurger
    let operationQueue: AsyncQueue
    let lockQueue = dispatch_queue_create("com.thoughtbot.pop-n-lock", nil)
    var operations: [String: NSOperation] = [:]

    init() {
        imageCache = Cache<UIImage>()
        purger = CachePurger(cache: imageCache)
        operationQueue = AsyncQueue(name: "PoppinsCacheQueue", maxOperations: 10)
    }

    func fetchImage(size: CGSize, path: String) -> UIImage? {
        if let image = imageCache.itemForKey(path) {
            return image
        } else {
            dispatch_sync(lockQueue) {
                if contains(self.operations.keys, path) { return }

                let operation = ImageFetchOperation(size: size, path: path) {
                    curry(self.imageCache.setItem) <^> $0 <*> path
                    dispatch_sync(self.lockQueue) {
                        _ = self.operations.removeValueForKey(path)
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("CacheDidUpdate", object: .None)
                }
                self.operationQueue.addOperation(operation)
                self.operations[path] = operation
            }
            return .None
        }
    }
}
