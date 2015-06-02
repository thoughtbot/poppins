import UIKit

extension UIViewController {
    func moveToParent(parent: UIViewController, @noescape handleMove: UIView -> ()) {
        willMoveToParentViewController(parent)
        parent.addChildViewController(self)
        handleMove(view)
        didMoveToParentViewController(parent)
    }

    func removeFromParent(handleMove: (() -> ())?) {
        willMoveToParentViewController(.None)
        view.removeFromSuperview()
        handleMove?()
        removeFromParentViewController()
        didMoveToParentViewController(.None)
    }
}
