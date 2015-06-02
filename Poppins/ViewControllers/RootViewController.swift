import UIKit

class RootViewController: UIViewController {
    var controller: RootController?
    var activeViewController: UIViewController?

    var initialViewController: UIViewController {
        if controller?.isLinked ?? false {
            return cascadeViewController
        } else {
            return linkAccountViewController
        }
    }

    var linkAccountViewController: LinkAccountViewController {
        let storyboard = UIStoryboard(name: "Authentication", bundle: .None)
        let vc = storyboard.instantiateInitialViewController() as! LinkAccountViewController
        vc.controller = controller?.linkAccountController
        return vc
    }

    var cascadeViewController: UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: .None)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! CascadeViewController
        vc.controller = controller?.cascadeController
        return nav
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showViewController(initialViewController)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "transitionToMainFlow", name: AccountLinkedNotificationName, object: .None)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func transitionToMainFlow() {
        let cascade = cascadeViewController
        cascade.moveToParent(self) { childView in
            childView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            view.sendSubviewToBack(childView)
        }

        transitionFromViewController(activeViewController!, toViewController: cascade, duration: 0.33, options: .CurveEaseInOut, animations: {
            cascade.view.transform = CGAffineTransformIdentity
            self.activeViewController?.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.height)
        }) { _ in
            self.activeViewController?.removeFromParent(.None)
            self.activeViewController = cascade
        }
    }

    func showViewController(viewController: UIViewController) {
        viewController.moveToParent(self) { childView in
            childView.frame = view.bounds
            view.addSubview(childView)
        }

        activeViewController = viewController
    }
}
