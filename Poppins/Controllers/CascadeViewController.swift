import Cascade

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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if !SyncManager.sharedManager.isLinked() {
            performSegueWithIdentifier("LinkAccountSegue", sender: self)
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func reloadFiles() {
        switch SyncManager.sharedManager.getFiles() {
        case let .Success(files): images = files._value
        case .Error(_): return
        }
        collectionView?.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PoppinsCell", forIndexPath: indexPath) as PoppinsCell

        let result = SyncManager.sharedManager.getFile(images[indexPath.row])
        cell.configureWithImageData <^> result
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let result = SyncManager.sharedManager.getFile(images[indexPath.row])
        return result.toOptional() >>- imageForData >>- imageSizeConstrainedByWidth(100.0) ?? CGSize(width: 1, height: 1)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: CascadeLayout, numberOfColumnsInSectionAtIndexPath indexPath: NSIndexPath) -> Int {
        return 2
    }
}
