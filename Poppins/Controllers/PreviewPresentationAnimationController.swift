import Foundation
import UIKit
import Runes

class PreviewPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let startingFrame: CGRect
    let duration: NSTimeInterval = 0.3

    init(isPresenting: Bool, startingFrame: CGRect) {
        self.isPresenting = isPresenting
        self.startingFrame = startingFrame
        super.init()
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }

    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? PreviewViewController
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let containerView = transitionContext.containerView()

        let finalFrame = presentedController.map { transitionContext.finalFrameForViewController($0) }
        presentedControllerView?.frame = startingFrame
        presentedController?.gifView.frame = CGRect(origin: CGPointZero, size: startingFrame.size)
        presentedControllerView?.alpha = 0
        presentedControllerView.map(containerView.addSubview)

        let options = UIViewAnimationOptions.AllowAnimatedContent | UIViewAnimationOptions.LayoutSubviews

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: options, animations: {
            presentedControllerView?.alpha = 1
            presentedControllerView?.frame = finalFrame ?? CGRectZero
            return
            }, completion: { completed in
                transitionContext.completeTransition(completed)
        })
    }

    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let containerView = transitionContext.containerView()

        let options = UIViewAnimationOptions.AllowAnimatedContent | UIViewAnimationOptions.LayoutSubviews

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: options, animations: {
            presentedControllerView?.alpha = 0
            presentedControllerView?.frame = self.startingFrame
            return
            }, completion: { completed in
                transitionContext.completeTransition(completed)
        })
    }
}
