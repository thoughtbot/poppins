import Cascade
import Gifu
import LlamaKit
import Runes

class CascadeViewController: UICollectionViewController, CascadeLayoutDelegate {
    var images: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView?.collectionViewLayout as? CascadeLayout
        layout?.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadFiles", name: PreloadCompletedNotificationName, object: .None)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if SyncManager.sharedManager.isLinked() {
            reloadFiles()
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func reloadFiles() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [unowned self] in
            self.images = SyncManager.sharedManager.getFiles() ?? []
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                _ = self.collectionView?.reloadData()
            }
        }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PoppinsCell", forIndexPath: indexPath) as PoppinsCell
        cell.configureWithImagePath <^> safeValue(images, indexPath.row)
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let path = safeValue(images, indexPath.row)
        let data: Result<NSData, NSError> = path.toResult() >>- SyncManager.sharedManager.getFile
        return ({ $0.size } <^> data.value >>- imageForData) ?? CGSize(width: 1, height: 1)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: CascadeLayout, numberOfColumnsInSectionAtIndexPath indexPath: NSIndexPath) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imagePath = safeValue(images, indexPath.row)
        let data = imagePath >>- { SyncManager.sharedManager.getFile($0).value }
        let gifItemSource = GifItemSource.create <^> data

        if let source = gifItemSource {
            let activityVC = UIActivityViewController(activityItems: [source], applicationActivities: [])
            presentViewController(activityVC, animated: true, completion: .None)
        }
    }
}
