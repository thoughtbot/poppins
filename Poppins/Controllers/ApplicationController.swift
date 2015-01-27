@objc class ApplicationController {
    let manager = SyncManager(service: UnconfiguredService())

    var linkedService: Service {
        get {
            let str = NSUserDefaults.standardUserDefaults().objectForKey(StoredServiceKey) as? String
            return Service(string: str) ?? .Unconfigured
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.description, forKey: StoredServiceKey)
        }
    }

    var rootViewController: UIViewController {
        let vc = RootViewController()
        vc.controller = RootController(manager: manager)
        return vc
    }

    func configureLinkedService() {
        HockeyManager.configure()

        switch linkedService {
        case .Dropbox: manager.setService(DropboxService())
        case .Unconfigured: manager.setService(UnconfiguredService())
        }

        manager.setup()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLinkedService", name: AccountLinkedNotificationName, object: .None)
    }

    func configureApplication() {
        ApplicationAppearance.setupAppearance()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setLinkedService() {
        linkedService = manager.type
    }

    func handleExternalURL(url: NSURL) -> Bool {
        return manager.finalizeAuthentication(url)
    }
}
