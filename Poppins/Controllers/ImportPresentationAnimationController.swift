import UIKit
import Runes

class ImportPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let size: CGSize
    let duration: NSTimeInterval

    init(isPresenting: Bool, size: CGSize, duration: NSTimeInterval = 0.3) {
        self.isPresenting = isPresenting
        self.size = size
        self.duration = duration
        super.init()
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }

    var animationOptions: UIViewAnimationOptions {
        return [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.LayoutSubviews, UIViewAnimationOptions.CurveEaseInOut]
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }

    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ImportViewController
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()!

        let finalFrame = transitionContext.finalFrameForViewController(presentedController)
        let yOffset = CGRectGetMidY(containerView.bounds) + size.height / 2
        presentedControllerView.frame = containerView.bounds.centeredRectForSize(size, offset: CGPoint(x: 0, y: yOffset))
        containerView.addSubview(presentedControllerView)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: animationOptions, animations: {
            presentedControllerView.frame = finalFrame
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }

    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()!

        let yOffset = CGRectGetMidY(containerView.bounds) + size.height / 2
        let finalFrame = containerView.bounds.centeredRectForSize(size, offset: CGPoint(x: 0, y: yOffset))

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: animationOptions, animations: {
            presentedControllerView.frame = finalFrame
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }
}
