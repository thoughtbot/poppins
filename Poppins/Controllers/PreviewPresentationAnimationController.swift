import Foundation
import UIKit
import Runes

class PreviewPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let startingFrame: CGRect
    let duration: NSTimeInterval

    init(isPresenting: Bool, startingFrame: CGRect, duration: NSTimeInterval = 0.3) {
        self.isPresenting = isPresenting
        self.startingFrame = startingFrame
        self.duration = duration
        super.init()
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }

    var animationOptions: UIViewAnimationOptions {
        return [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.LayoutSubviews]
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }

    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! PreviewViewController
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()!

        let finalFrame = transitionContext.finalFrameForViewController(presentedController)
        presentedControllerView.frame = startingFrame
        presentedController.gifView.frame = CGRect(origin: CGPointZero, size: startingFrame.size)
        presentedControllerView.alpha = 0
        containerView.addSubview(presentedControllerView)

        let midPoint = CGPoint(x: startingFrame.width / 2, y: startingFrame.height / 2)
        presentedController?.activityIndicator.frame = CGRect(origin: midPoint, size: presentedController?.activityIndicator.frame.size ?? CGSizeZero)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: animationOptions, animations: {
            presentedControllerView.alpha = 1
            presentedControllerView.frame = finalFrame
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }

    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: animationOptions, animations: {
            presentedControllerView.alpha = 0
            presentedControllerView.frame = self.startingFrame
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }
}
