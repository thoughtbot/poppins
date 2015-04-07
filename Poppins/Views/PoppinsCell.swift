import Runes
import CoreGraphics

@IBDesignable
class PoppinsCell: UICollectionViewCell, ViewModelObserver {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var shadowView: UIView?
    @IBOutlet weak var rootView: UIView?

    @IBInspectable var cornerRadius: CGFloat = 6.0

    @IBInspectable var shadowColor: UIColor = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.75
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    @IBInspectable var shadowSpread: CGFloat = 14

    var controller: PoppinsCellController? {
        didSet {
            controller?.observer = self
            viewModelDidChange()
            controller?.fetchImage <*> self.frame.size
        }
    }

    func viewModelDidChange() {
        dispatch_async(dispatch_get_main_queue()) {
            self.imageView?.image = self.controller?.viewModel.image
            return
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCornerRadius()
        setupDropShadow()
    }
}

extension PoppinsCell {
    func setupCornerRadius() {
        rootView?.layer.cornerRadius = cornerRadius
    }

    func setupDropShadow() {
        shadowView?.layer.shadowColor = shadowColor.CGColor
        shadowView?.layer.shadowOpacity = shadowOpacity
        shadowView?.layer.shadowOffset = shadowOffset
        shadowView?.layer.shadowRadius = shadowSpread
        shadowView?.layer.shouldRasterize = true
        shadowView?.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
}

extension PoppinsCell {
    override func prepareForInterfaceBuilder() {
        layoutSubviews()
    }
}
