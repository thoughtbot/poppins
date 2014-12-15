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

    func configureWithImageData(data: NSData) {
        let size = imageSizeConstrainedByWidth(frame.width) <^> UIImage(data: data) ?? CGSizeZero
        let image = AnimatedImage(data: data, size: size)
        imageView?.setAnimatedImage(image)
        imageView?.startAnimatingGIF()
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
