import Gifu
import Runes

class ImageFetcher {
    let imageCache: Cache<[AnimatedFrame]>
    let purger: CachePurger
    let operationQueue: AsyncQueue
    let manager: SyncManager

    init(manager: SyncManager) {
        imageCache = Cache<[AnimatedFrame]>()
        purger = CachePurger(cache: imageCache)
        operationQueue = AsyncQueue(name: "PoppinsCacheQueue", maxOperations: 10)
        self.manager = manager
    }

    func fetchImage(size: CGSize, path: String, callback: ([AnimatedFrame] -> ())?) {
        if let image = imageCache.itemForKey(path) {
            callback?(image)
        } else {
            let operation = NSBlockOperation(block: { [unowned self] in
                self.purger.thumbsUpGoodJob()
                let image = curry(AnimatedFrame.createWithData)
                        <^> self.manager.getFile(path).value
                        <*> size

                curry(self.imageCache.setItem) <^> image <*> path
                callback <*> image
            })
            operationQueue.addOperation(operation)
        }
    }
}
