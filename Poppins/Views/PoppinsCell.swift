import Gifu

@IBDesignable
class PoppinsCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var shadowView: UIView?

    @IBInspectable var cornerRadius: CGFloat = 6.0

    @IBInspectable var shadowColor: UIColor = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.75
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    @IBInspectable var shadowSpread: CGFloat = 14

    func configureWithImagePath(path: String) {
        let image = ImageCache.cachedImageForPath(path) ??
            curry(AnimatedImage.animatedImageWithData)
                <^> SyncManager.sharedManager.getFile(path).toOptional()
                <*> imageView?.frame.size

        curry(ImageCache.cacheImage) <^> image <*> path

        if let x = image {
            imageView?.setAnimatedImage(x)
            imageView?.startAnimatingGIF()
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
        imageView?.layer.cornerRadius = cornerRadius
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
