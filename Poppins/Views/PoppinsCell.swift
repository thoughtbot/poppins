import Gifu
import Runes

@IBDesignable
class PoppinsCell: UICollectionViewCell, ViewModelObserver {
    @IBOutlet weak var animatedView: AnimatedView?
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
            controller?.fetchImage <*> animatedView?.frame.size
        }
    }

    func viewModelDidChange() {
        dispatch_async(dispatch_get_main_queue()) {
            self.animatedView?.setAnimatedFrames(self.controller?.viewModel.frames ?? [])
            self.animatedView?.resumeAnimation()
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
        rootView?.layer.cornerRadius = cornerRadius
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
