struct HockeyManager {
    static func configure() {
        let manager = BITHockeyManager.sharedHockeyManager()
        manager.configureWithIdentifier("fe9cf520171adf0c5010922e57bc2a83")
        manager.startManager()
        manager.authenticator.authenticateInstallation()
    }
}