import UIKit

class PreviewTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let startingFrame: CGRect

    init(startingFrame: CGRect) {
        self.startingFrame = startingFrame
        super.init()
    }

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        let controller = PreviewPresentationController(presentedViewController: presented, presentingViewController: presenting)
        controller.frame = startingFrame
        return controller
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PreviewPresentationAnimationController(isPresenting: true, startingFrame: startingFrame)
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PreviewPresentationAnimationController(isPresenting: false, startingFrame: startingFrame)
    }
}
