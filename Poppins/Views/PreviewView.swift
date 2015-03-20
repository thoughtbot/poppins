import Gifu
import Runes

class PreviewView: UIView, ViewModelObserver {
    @IBOutlet weak var gifView: AnimatableImageView!
    @IBOutlet weak var gifHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gifWidthConstraint: NSLayoutConstraint!

    var controller: PreviewController? {
        didSet {
            gifWidthConstraint.constant = frame.width
            gifHeightConstraint.constant = frame.height

            let aspectRatioConstraint = NSLayoutConstraint(item: gifView, attribute: .Height, relatedBy: NSLayoutRelation.Equal, toItem: gifView, attribute: .Width, multiplier: controller?.size.height ?? 1, constant: 0)
            gifView.addConstraint(aspectRatioConstraint)

            controller?.observer = self
            controller?.loadData()
        }
    }

    func viewModelDidChange() {
        { _ = self.gifView?.animateWithImageData(data: $0.gifData) } <^> controller?.viewModel
        gifView?.startAnimatingGIF()
    }

    class func create() -> PreviewView? {
        return NSBundle.mainBundle().loadNibNamed("PreviewView", owner: self, options: .None).first as? PreviewView
    }
}
