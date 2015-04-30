import UIKit

class ImportTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let size: CGSize = CGSize(width: 216, height: 355)

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
       return ImportPresentationController(presentedViewController: presented, presentingViewController: presenting, size: size)
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImportPresentationAnimationController(isPresenting: true, size: size)
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImportPresentationAnimationController(isPresenting: false, size: size)
    }
}
