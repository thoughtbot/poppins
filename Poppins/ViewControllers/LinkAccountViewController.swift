class LinkAccountViewController: UIViewController {
    @IBOutlet weak var syncingView: UIView!
    @IBOutlet weak var syncingViewOffsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var linkDropboxButton: Button!

    var controller: LinkAccountController?

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "authSuccessful", name: AccountLinkedNotificationName, object: .None)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "initialSyncCompleted", name: InitialSyncCompletedNotificationName, object: .None)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func authSuccessful() {
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(1.0) {
                self.syncingView.alpha = 1.0
            }
        }
    }

    func initialSyncCompleted() {
        NSNotificationCenter.defaultCenter().postNotificationName("LinkingComplete", object: .None)
    }
    
    @IBAction func linkDropbox() {
        controller?.linkAccount(self)
    }
}
