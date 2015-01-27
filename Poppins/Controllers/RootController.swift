class RootController {
    var isLinked: Bool {
        return SyncManager.sharedManager.isLinked()
    }

    var linkAccountController: LinkAccountController {
        return LinkAccountController()
    }

    var cascadeController: CascadeController {
        return CascadeController()
    }
}
