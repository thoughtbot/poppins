struct LinkAccountController {
    let manager: SyncManager

    func linkAccount(parent: UIViewController) {
        manager.setService(DropboxService())
        manager.setup()
        manager.initiateAuthentication(parent)
    }
}
