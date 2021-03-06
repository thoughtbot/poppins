import UIKit
import Runes
import Gifu

class PreviewViewController: UIViewController, ViewModelObserver {
    @IBOutlet weak var gifView: AnimatableImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var controller: PreviewController? {
        didSet {
            controller?.observer = self
            controller?.loadData()
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    deinit {
        gifView.cleanup()
    }

    func setup() {
        modalPresentationStyle = .Custom
    }

    func viewModelDidChange() {
        { _ = self.gifView?.animateWithImageData(data: $0.gifData) } <^> self.controller?.viewModel
    }
}

extension PreviewViewController {
    class func create() -> PreviewViewController {
        return PreviewViewController(nibName: "PreviewView", bundle: .None)
    }
}
