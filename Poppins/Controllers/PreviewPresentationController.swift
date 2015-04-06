import UIKit

private let PreviewGIFPadding: CGFloat = 20

class PreviewPresentationController: UIPresentationController {
    let dimmingView = UIView()
    let frame: CGRect

    init(presentedViewController: UIViewController!, presentingViewController: UIViewController!, frame: CGRect) {
        assert(frame.height != 0)
        self.frame = frame
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView.bounds
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurView.frame = containerView.bounds
        dimmingView.addSubview(blurView)
        dimmingView.alpha = 0

        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedView())

        let transitionCoordinator = presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ _ in
            self.dimmingView.alpha = 1
        }, completion: .None)
    }

    override func presentationTransitionDidEnd(completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ _ in
            self.dimmingView.alpha = 0
        }, completion: .None)
    }

    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }

    override func frameOfPresentedViewInContainerView() -> CGRect {
        let bounds = containerView.bounds
        let fullSize = CGSize(width: bounds.width - PreviewGIFPadding, height: bounds.height - PreviewGIFPadding)
        let aspectRatio = frame.width / frame.height

        let aspectHeight = fullSize.width / aspectRatio
        let aspectWidth = fullSize.height * aspectRatio

        let size: CGSize

        if aspectHeight > fullSize.height {
            size = CGSize(width: aspectWidth, height: fullSize.height)
        } else {
            size = CGSize(width: fullSize.width, height: aspectHeight)
        }

        let point = CGPoint(x: round((bounds.width - size.width) / 2), y: round((bounds.height - size.height) / 2))
        return CGRect(origin: point, size: size)
    }
}
