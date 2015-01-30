struct RootController {
    let manager: LinkManager

    var isLinked: Bool {
        return manager.isLinked()
    }

    var linkAccountController: LinkAccountController {
        return LinkAccountController(manager: manager)
    }

    var cascadeController: CascadeController {
        return CascadeController(syncClient: manager.client)
    }
}
