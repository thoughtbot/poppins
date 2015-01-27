class CascadeController {
    let manager: SyncManager
    var observer: ViewModelObserver?

    var viewModel: CascadeViewModel {
        didSet {
            observer?.viewModelDidChange()
        }
    }

    init(manager: SyncManager) {
        self.manager = manager
        viewModel = CascadeViewModel(manager: manager, images: [])
    }

    func fetchImages() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [unowned self] in
            let images = self.manager.getFiles()
            self.viewModel = CascadeViewModel(manager: self.manager, images: images.value ?? [])
        }
    }

    func cellControllerForIndexPath(indexPath: NSIndexPath) -> PoppinsCellController? {
        let path = viewModel.imagePathForIndexPath(indexPath)
        return PoppinsCellController(manager: manager, path: path ?? "")
    }
}
