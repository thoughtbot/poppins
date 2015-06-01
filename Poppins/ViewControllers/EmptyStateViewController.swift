import UIKit

private let GiphyURLString = "http://www.giphy.com"

class EmptyStateViewController: UIViewController {
    @IBAction func navigateToGiphy() {
        UIApplication.sharedApplication().openURL(NSURL(string: GiphyURLString)!)
    }
}

extension EmptyStateViewController {
    static func create() -> EmptyStateViewController {
        return EmptyStateViewController(nibName: "EmptyState", bundle: .None)
    }
}
