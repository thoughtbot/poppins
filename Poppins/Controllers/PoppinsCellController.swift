import Runes

class PoppinsCellController {
    let imageFetcher: ImageFetcher
    let path: String
    var observer: ViewModelObserver?
    var size = CGSizeZero

    var viewModel: PoppinsCellViewModel {
        didSet {
            observer?.viewModelDidChange()
        }
    }

    init(imageFetcher: ImageFetcher, path: String) {
        self.imageFetcher = imageFetcher
        self.path = path
        viewModel = PoppinsCellViewModel(image: .None)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func fetchImage(size: CGSize) {
        self.size = size
        if let image = imageFetcher.fetchImage(size, path: path) {
            viewModel = PoppinsCellViewModel(image: image)
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "cacheDidUpdate", name: "CacheDidUpdate", object: .None)
        }
    }

    @objc func cacheDidUpdate() {
        if let image = imageFetcher.fetchImage(size, path: path) {
            viewModel = PoppinsCellViewModel(image: image)
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
}
