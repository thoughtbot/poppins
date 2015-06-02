class PopupViewManager {
    private var previewViewController: PreviewViewController?
    private var previewTransitionDelegate: PreviewTransitioningDelegate?
    private var importViewController: ImportViewController?
    private var importTransitionDelegate: ImportTransitioningDelegate?

    func previewViewController(startingFrame: CGRect)(path: String)(size: CGSize) -> PreviewViewController {
        previewTransitionDelegate = PreviewTransitioningDelegate(startingFrame: startingFrame)
        previewViewController = PreviewViewController.create()
        previewViewController?.transitioningDelegate = previewTransitionDelegate
        previewViewController?.controller = PreviewController(path: path, size: size)
        return previewViewController!
    }

    func importViewController(controller: ImportController) -> ImportViewController {
        importTransitionDelegate = ImportTransitioningDelegate()
        importViewController = ImportViewController.create()
        importViewController?.transitioningDelegate = importTransitionDelegate
        importViewController?.controller = controller
        return importViewController!
    }
}
