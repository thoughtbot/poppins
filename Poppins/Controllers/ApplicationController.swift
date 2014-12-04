@objc class ApplicationController {
    var linkedService: Service {
        get {
            let str = NSUserDefaults.standardUserDefaults().objectForKey(StoredServiceKey) as? String
            return Service(string: str) ?? .Unconfigured
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.description, forKey: StoredServiceKey)
        }
    }

    func configureLinkedService() {
        switch linkedService {
        case .Dropbox: SyncManager.sharedManager.setService(DropboxService())
        case .Unconfigured: SyncManager.sharedManager.setService(UnconfiguredService())
        }

        SyncManager.sharedManager.setup()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLinkedService", name: AccountLinkedNotificationName, object: .None)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setLinkedService() {
        linkedService = SyncManager.sharedManager.type
    }
}
