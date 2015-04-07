import Foundation
import Runes

class ImageFetcher {
    let imageCache: Cache<UIImage>
    let purger: CachePurger
    let operationQueue: AsyncQueue
    let lockQueue = dispatch_queue_create("com.thoughtbot.pop-n-lock", nil)
    var inProgress: [String] = []

    init() {
        imageCache = Cache<UIImage>()
        purger = CachePurger(cache: imageCache)
        operationQueue = AsyncQueue(name: "PoppinsCacheQueue", maxOperations: NSOperationQueueDefaultMaxConcurrentOperationCount)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveMemoryWarning"), name: UIApplicationDidReceiveMemoryWarningNotification, object: .None)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func didReceiveMemoryWarning() {
        inProgress = []
    }

    func fetchImage(size: CGSize, path: String) -> UIImage? {
        if let image = imageCache.itemForKey(path) {
            return image
        } else {
            if size == CGSizeZero { return .None }
            dispatch_async(lockQueue) {
                if contains(self.inProgress, path) { return }

                let operation = ImageFetcherOperation(path: path, size: size) { image in
                    dispatch_async(self.lockQueue) {
                        curry(self.imageCache.setItem) <^> image <*> path
                        self.inProgress.removeAtIndex <^> find(self.inProgress, path)
                        NSNotificationCenter.defaultCenter().postNotificationName("CacheDidUpdate", object: .None)
                    }
                }
                self.operationQueue.addOperation(operation)
            }
            return .None
        }
    }
}

