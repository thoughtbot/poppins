import Gifu
import Runes

private let ImageCache = Cache<[AnimatedFrame]>()
private let purger = CachePurger(cache: ImageCache)
private let operationQueue = AsyncQueue(name: "PoppinsCacheQueue", maxOperations: 10)

class PoppinsCellController {
    let manager: SyncManager
    let path: String
    var observer: ViewModelObserver?
    private var operation: NSBlockOperation?

    var viewModel: PoppinsCellViewModel {
        didSet {
            observer?.viewModelDidChange()
        }
    }

    init(manager: SyncManager, path: String) {
        self.manager = manager
        self.path = path
        viewModel = PoppinsCellViewModel(frames: [])
    }

    deinit {
        operation?.cancel()
    }

    func fetchImage(size: CGSize) {
        operation = NSBlockOperation(block: { [unowned self] in
            _ = self.getImage(size)
        })
        operationQueue.addOperation <^> operation
    }

    func getImage(size: CGSize) {
        purger.thumbsUpGoodJob()
        var image = ImageCache.itemForKey(path)

        if image == nil {
            if operation?.cancelled ?? true { return }
            image = curry(AnimatedFrame.createWithData)
                <^> manager.getFile(path).value
                <*> size

            curry(ImageCache.setItem) <^> image <*> path
        }

        if let x = image {
            if operation?.cancelled ?? true { return }
            viewModel = PoppinsCellViewModel(frames: x)
        }
    }
}
