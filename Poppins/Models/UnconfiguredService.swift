class UnconfiguredService: LinkableService {
    let type: Service = .Unconfigured

    func setup() {}

    func initiateAuthentication<T>(_: T) {}

    func finalizeAuthentication(_: NSURL) -> Bool {
        return false
    }

    func isLinked() -> Bool {
        return false
    }

    func unLink() {}
}
