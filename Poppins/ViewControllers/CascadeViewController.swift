import Cascade
import Gifu
import LlamaKit
import Runes

class CascadeViewController: UICollectionViewController, CascadeLayoutDelegate, ViewModelObserver {
    var controller: CascadeController? {
        didSet {
            controller?.observer = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView?.collectionViewLayout as? CascadeLayout
        layout?.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchImages", name: PreloadCompletedNotificationName, object: .None)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchImages()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func fetchImages() {
        controller?.fetchImages()
    }

    func viewModelDidChange() {
//        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            _ = self.collectionView?.reloadData()
//        }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller?.viewModel.numberOfImages ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PoppinsCell", forIndexPath: indexPath) as PoppinsCell
        cell.configureWithImagePath <^> controller?.viewModel.imagePathForIndexPath(indexPath)
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
