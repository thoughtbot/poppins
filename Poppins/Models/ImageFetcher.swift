import Foundation
import Runes

class ImageFetcher {
    let imageCache: Cache<UIImage>
    let purger: CachePurger
    let lockQueue = dispatch_queue_create("com.thoughtbot.pop-n-lock", nil)
    var inProgress: [String] = []

    init() {
        imageCache = Cache<UIImage>()
        purger = CachePurger(cache: imageCache)
    }

    func fetchImage(size: CGSize, path: String) -> UIImage? {
        if size == CGSizeZero { return .None }

        if let image = imageCache.itemForKey(path) {
            return image
        } else {
            dispatch_async(lockQueue) {
                if contains(self.inProgress, path) { return }

                let data = NSData(contentsOfFile: path)
                let image = data >>- imageForData
                let scaledImage = image?.imageForSize(size)

                curry(self.imageCache.setItem) <^> scaledImage <*> path

                self.inProgress.removeAtIndex <^> find(self.inProgress, path)
                NSNotificationCenter.defaultCenter().postNotificationName("CacheDidUpdate", object: .None)
            }
            return .None
        }
    }
}
