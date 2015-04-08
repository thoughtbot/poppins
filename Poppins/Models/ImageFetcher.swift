import Foundation
import Runes

@objc class ImageFetcher {
    let imageCache: Cache<UIImage>
    let purger: CachePurger
    let operationQueue: AsyncQueue
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

            dispatch_to_main {
                objc_sync_enter(self.inProgress)
                if contains(self.inProgress, path) { return }
                self.inProgress.append(path)
                objc_sync_exit(self.inProgress)
                
                let operation = ImageFetcherOperation(path: path, size: size) { image in
                    curry(self.imageCache.setItem) <^> image <*> path
                    
                    dispatch_to_main {
                        objc_sync_enter(self.inProgress)
                        self.inProgress.removeAtIndex <^> find(self.inProgress, path)
                        objc_sync_exit(self.inProgress)
                        NSNotificationCenter.defaultCenter().postNotificationName("CacheDidUpdate", object: .None)
                    }
                }
                
                self.operationQueue.addOperation(operation)
            }
            return .None
        }
    }
}
