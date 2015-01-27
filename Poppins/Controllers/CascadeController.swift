class CascadeController {
    var observer: ViewModelObserver?

    var viewModel: CascadeViewModel {
        didSet {
            observer?.viewModelDidChange()
        }
    }

    init() {
        viewModel = CascadeViewModel(images: [])
    }

    func fetchImages() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [unowned self] in
            let images = SyncManager.sharedManager.getFiles()
            self.viewModel = CascadeViewModel(images: images.value ?? [])
        }
    }
}
