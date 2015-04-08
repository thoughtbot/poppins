@objc class ApplicationController {
    let manager = LinkManager(service: UnconfiguredService())

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
        switch linkedService {
        case .Dropbox: manager.setService(DropboxService())
        default: break
        }

        manager.setup()

        if !manager.isLinked() {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLinkedService", name: AccountLinkedNotificationName, object: .None)
        }
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
