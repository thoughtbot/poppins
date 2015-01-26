import UIKit

class RootViewController: UIViewController {
    var controller: RootController?
    var activeViewController: UIViewController?

    var initialViewController: UIViewController {
        if controller?.isLinked ?? false {
            return linkAccountViewController
        } else {
            return cascadeViewController
        }
    }

    var linkAccountViewController: LinkAccountViewController {
        let storyboard = UIStoryboard(name: "Authentication", bundle: .None)
        let vc = storyboard.instantiateInitialViewController() as LinkAccountViewController
        return vc
    }

    var cascadeViewController: CascadeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .None)
        let nav = storyboard.instantiateInitialViewController() as UINavigationController
        let vc = nav.topViewController as CascadeViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showViewController(initialViewController)
    }

    func showViewController(viewController: UIViewController) {
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)

        activeViewController = viewController
    }
}
