import UIKit

class PreviewPresentationController: UIPresentationController {
    let dimmingView = UIView()
    var frame: CGRect = CGRectZero

    override func presentationTransitionWillBegin() {
        dimmingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        dimmingView.frame = containerView.bounds
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
        let fullSize = CGSize(width: bounds.width - 20, height: bounds.height - 20)
        let aspectRatio = frame.width / (frame.height == 0 ? 1 : frame.height)

        let aspectHeight = fullSize.width / aspectRatio
        let aspectWidth = fullSize.height * aspectRatio

        if aspectHeight > fullSize.height {
            let size = CGSize(width: aspectWidth, height: fullSize.height)
            let point = CGPoint(x: (bounds.width - size.width) / 2, y: (bounds.height - size.height) / 2)
            return CGRect(origin: point, size: size)
        } else {
            let size = CGSize(width: fullSize.width, height: aspectHeight)
            let point = CGPoint(x: (bounds.width - size.width) / 2, y: (bounds.height - size.height) / 2)
            return CGRect(origin: point, size: size)
        }
    }
}
