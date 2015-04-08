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

        let layout = collectionView?.collectionViewLayout as? CascadeLayout
        layout?.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("sync"), name: UIApplicationDidBecomeActiveNotification, object: .None)
        sync()

        holdGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "hold:")
        holdGestureRecognizer?.minimumPressDuration = 0.5
        holdGestureRecognizer >>- { self.collectionView?.addGestureRecognizer($0) }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchImages()
    }

    @objc func sync() {
        controller?.syncWithTHECLOUD()
    }

    func fetchImages() {
        controller?.fetchImages()
        controller?.registerForChanges { inserted, updated, deleted in
            _ = self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItemsAtIndexPaths(inserted)
                self.collectionView?.reloadItemsAtIndexPaths(updated)
                self.collectionView?.deleteItemsAtIndexPaths(deleted)
            }, completion: .None)
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
            let activityVC = UIActivityViewController(activityItems: [source], applicationActivities: [])
            presentViewController(activityVC, animated: true, completion: .None)
        }
    }

    var preview: PreviewView?

    func hold(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            let point = gesture.locationInView(collectionView)
            let indexPath = collectionView?.indexPathForItemAtPoint(point)
            let path = indexPath >>- { self.controller?.viewModel.imagePathForIndexPath($0) }
            let size = indexPath >>- { self.controller?.viewModel.imageSizeForIndexPath($0) }

            preview = PreviewView.create()
            preview?.controller = path >>- { p in size.map { PreviewController(path: p, size: $0) } }
            preview?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            preview.map { self.view.addSubview($0) }
        } else if gesture.state == .Ended {
            preview?.removeFromSuperview()
            preview = .None
        }
    }
}
