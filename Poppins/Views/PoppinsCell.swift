import Gifu

private let ImageCache = Cache<[AnimatedFrame]>()

@IBDesignable
class PoppinsCell: UICollectionViewCell {
    @IBOutlet weak var animatedView: AnimatedView?
    @IBOutlet weak var shadowView: UIView?

    @IBInspectable var cornerRadius: CGFloat = 6.0

    @IBInspectable var shadowColor: UIColor = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.75
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    @IBInspectable var shadowSpread: CGFloat = 14

    func configureWithImagePath(path: String) {
        let image = ImageCache.itemForKey(path) ??
            curry(AnimatedFrame.createWithData)
                <^> SyncManager.sharedManager.getFile(path).toOptional()
                <*> animatedView?.frame.size

        curry(ImageCache.setItem) <^> image <*> path

        if let x = image {
            animatedView?.setAnimatedFrames(x)
            animatedView?.resumeAnimation()
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
