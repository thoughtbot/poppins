struct LinkAccountController {
    func linkAccount(parent: UIViewController) {
        SyncManager.sharedManager.setService(DropboxService())
        SyncManager.sharedManager.setup()
        SyncManager.sharedManager.initiateAuthentication(parent)
    }
}
