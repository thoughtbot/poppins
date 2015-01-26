class RootController {
    var isLinked: Bool {
        return SyncManager.sharedManager.isLinked()
    }
}
