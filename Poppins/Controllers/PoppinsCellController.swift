import Gifu
import Runes

class PoppinsCellController {
    let imageFetcher: ImageFetcher
    let path: String
    var observer: ViewModelObserver?

    var viewModel: PoppinsCellViewModel {
        didSet {
            observer?.viewModelDidChange()
        }
    }

    init(imageFetcher: ImageFetcher, path: String) {
        self.imageFetcher = imageFetcher
        self.path = path
        viewModel = PoppinsCellViewModel(frames: [])
    }

    deinit {
        imageFetcher.cancelFetchForImageAtPath(path)
    }

    func fetchImage(size: CGSize) {
        imageFetcher.fetchImage(size, path: path) {
            self.viewModel = PoppinsCellViewModel(frames: $0)
        }
    }
}
