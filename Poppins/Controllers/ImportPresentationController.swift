import UIKit

class ImportPresentationController: UIPresentationController {
    let dimmingView = UIView()
    let size: CGSize

    init(presentedViewController: UIViewController!, presentingViewController: UIViewController!, size: CGSize) {
        self.size = size
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
        return bounds.centeredRectForSize(size)
    }
}
