protocol LinkableService {
    var type: Service { get }

    func setup()
    func initiateAuthentication<T>(T)
    func finalizeAuthentication(NSURL) -> Bool
    func isLinked() -> Bool
    func unLink()
}
