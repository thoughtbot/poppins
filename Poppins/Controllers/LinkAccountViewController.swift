class LinkAccountViewController: UIViewController {
    @IBOutlet weak var syncingView: UIView!
    @IBOutlet weak var syncingViewOffsetConstraint: NSLayoutConstraint!

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
        dispatch_async(dispatch_get_main_queue()) {
            _ = self.presentingViewController?.dismissViewControllerAnimated(true, completion: .None)
        }
    }
    
    @IBAction func linkDropbox() {
        SyncManager.sharedManager.setService(DropboxService())
        SyncManager.sharedManager.setup()
        SyncManager.sharedManager.initiateAuthentication(self)
    }
}
