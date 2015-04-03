import Foundation
import UIKit
import Runes

class PreviewPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let startingFrame: CGRect
    let duration: NSTimeInterval = 0.5

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
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let containerView = transitionContext.containerView()

        let finalFrame = presentedController.map { transitionContext.finalFrameForViewController($0) }
        presentedControllerView?.frame = startingFrame
        presentedControllerView?.alpha = 0
        presentedControllerView.map(containerView.addSubview)
        presentedControllerView?.setNeedsLayout()

        let options = UIViewAnimationOptions.AllowAnimatedContent | UIViewAnimationOptions.LayoutSubviews

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: options, animations: {
            presentedControllerView?.alpha = 1
            finalFrame >>- { presentedControllerView?.frame = $0 }
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
