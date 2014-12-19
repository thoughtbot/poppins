import Gifu

private let ImageCache = Cache<[AnimatedFrame]>()
private let operationQueue = AsyncQueue(name: "PoppinsCacheQueue", maxOperations: 10)

@IBDesignable
class PoppinsCell: UICollectionViewCell {
    @IBOutlet weak var animatedView: AnimatedView?
    @IBOutlet weak var shadowView: UIView?

    @IBInspectable var cornerRadius: CGFloat = 6.0

    @IBInspectable var shadowColor: UIColor = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.75
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    @IBInspectable var shadowSpread: CGFloat = 14

    private var operation: NSBlockOperation?

    func configureWithImagePath(path: String) {
        operation?.cancel()
        animatedView?.setAnimatedFrames([])
        operation = NSBlockOperation(block: { [unowned self] in self.fetchImage(path) })
        operationQueue.addOperation <^> operation
    }

    func fetchImage(path: String) {
        var image = ImageCache.itemForKey(path)
        if image == nil {
            if operation?.cancelled ?? true { return }
            image = curry(AnimatedFrame.createWithData)
                <^> SyncManager.sharedManager.getFile(path).toOptional()
                <*> animatedView?.frame.size

            curry(ImageCache.setItem) <^> image <*> path
        }

        if let x = image {
            if self.operation?.cancelled ?? true { return }
            dispatch_async(dispatch_get_main_queue()) {
                if self.operation?.cancelled ?? true { return }
                self.animatedView?.setAnimatedFrames(x)
                self.animatedView?.resumeAnimation()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadius()
        setupDropShadow()
    }
}

extension PoppinsCell {
    func setupCornerRadius() {
        animatedView?.layer.cornerRadius = cornerRadius
    }

    func setupDropShadow() {
        shadowView?.layer.shadowColor = shadowColor.CGColor
        shadowView?.layer.shadowOpacity = shadowOpacity
        shadowView?.layer.shadowOffset = shadowOffset
        shadowView?.layer.shadowRadius = shadowSpread
    }
}

extension PoppinsCell {
    override func prepareForInterfaceBuilder() {
        layoutSubviews()
    }
}
