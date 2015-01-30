import CoreData
import Cascade
import Gifu
import LlamaKit
import Runes

class CascadeViewController: UICollectionViewController, CascadeLayoutDelegate {
    var controller: CascadeController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView?.collectionViewLayout as? CascadeLayout
        layout?.delegate = self
        controller?.syncWithTHECLOUD()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchImages()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PoppinsCell", forIndexPath: indexPath) as PoppinsCell
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
}
