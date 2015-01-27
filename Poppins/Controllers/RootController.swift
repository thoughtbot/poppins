struct RootController {
    let manager: SyncManager

    var isLinked: Bool {
        return manager.isLinked()
    }

    var linkAccountController: LinkAccountController {
        return LinkAccountController(manager: manager)
    }

    var cascadeController: CascadeController {
        return CascadeController(manager: manager)
    }
}
