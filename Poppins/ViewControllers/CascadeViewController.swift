import CoreData
import Cascade
import Gifu
import LlamaKit
import Runes

class CascadeViewController: UICollectionViewController, CascadeLayoutDelegate {
    var controller: CascadeController?
    var holdGestureRecognizer: UILongPressGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavigationBarBackground"), forBarMetrics: .Default)

        let layout = collectionView?.collectionViewLayout as? CascadeLayout
        layout?.delegate = self
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("sync"), name: UIApplicationDidBecomeActiveNotification, object: .None)
        sync()

        holdGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "hold:")
        holdGestureRecognizer?.minimumPressDuration = 0.5
        holdGestureRecognizer >>- { self.collectionView?.addGestureRecognizer($0) }

        navigationItem.titleView = UIImage(named: "PoppinsTitle").map { UIImageView(image: $0) }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchImages()

        if controller?.viewModel.shouldShowEmptyState ?? true {
            showEmptyState()
        }
    }

    @objc func sync() {
        controller?.syncWithTHECLOUD()
    }

    func fetchImages() {
        controller?.fetchImages()
        controller?.registerForChanges { inserted, updated, deleted in
            self.hideEmptyState()
            _ = self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItemsAtIndexPaths(inserted)
                self.collectionView?.reloadItemsAtIndexPaths(updated)
                self.collectionView?.deleteItemsAtIndexPaths(deleted)
            }, completion: .None)
        }
    }

    func showEmptyState() {
        let emptyStateViewController = EmptyStateViewController.create()
        emptyStateViewController.willMoveToParentViewController(self)
        addChildViewController(emptyStateViewController)
        collectionView?.backgroundView = emptyStateViewController.view
        emptyStateViewController.didMoveToParentViewController(self)
    }

    func hideEmptyState() {
        if let emptyStateViewController = childViewControllers.last as? EmptyStateViewController {
            emptyStateViewController.willMoveToParentViewController(.None)
            emptyStateViewController.view.removeFromSuperview()
            collectionView?.backgroundView = .None
            emptyStateViewController.removeFromParentViewController()
            emptyStateViewController.didMoveToParentViewController(.None)
        }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller?.viewModel.numberOfImages ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PoppinsCell", forIndexPath: indexPath) as! PoppinsCell
        cell.controller = controller?.cellControllerForIndexPath(indexPath)
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return controller?.viewModel.imageSizeForIndexPath(indexPath) ?? CGSize(width: 1, height: 1)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: CascadeLayout, numberOfColumnsInSectionAtIndexPath indexPath: NSIndexPath) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let gifItemSource = controller?.viewModel.gifItemSourceForIndexPath(indexPath)

        if let source = gifItemSource {
            let activityVC = UIActivityViewController(activityItems: [source], applicationActivities: [FacebookMessengerActivity()])
            presentViewController(activityVC, animated: true, completion: .None)
        }
    }

    var previewViewController: PreviewViewController?
    var transitionDelegate: PreviewTransitioningDelegate?

    func hold(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            let point = gesture.locationInView(collectionView)
            let indexPath = collectionView?.indexPathForItemAtPoint(point)
            let frame = (indexPath >>- { self.collectionView?.layoutAttributesForItemAtIndexPath($0) })?.frame
            let realFrame = collectionView?.convertRect(frame!, toView: navigationController?.view)

            transitionDelegate = realFrame.map { PreviewTransitioningDelegate(startingFrame: $0) }
            previewViewController = PreviewViewController.create()
            previewViewController?.transitioningDelegate = transitionDelegate

            let path = indexPath >>- { self.controller?.viewModel.imagePathForIndexPath($0) }
            let size = indexPath >>- { self.controller?.viewModel.imageSizeForIndexPath($0) }

            previewViewController?.controller = path >>- { p in size.map { PreviewController(path: p, size: $0) } }
            previewViewController.map { self.presentViewController($0, animated: true, completion: .None) }
        } else if gesture.state == .Ended {
            dismissViewControllerAnimated(true, completion: .None)
        }
    }
}
