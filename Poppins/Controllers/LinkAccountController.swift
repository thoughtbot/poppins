struct LinkAccountController {
    let manager: LinkManager

    func linkAccount(parent: UIViewController) {
        manager.setService(DropboxService())
        manager.setup()
        manager.initiateAuthentication(parent)
    }
}
