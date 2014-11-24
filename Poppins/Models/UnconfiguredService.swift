public class UnconfiguredService: SyncableService {
    public let type: Service = .Unconfigured

    public func setup() {}

    public func initiateAuthentication<A>(_: A) {}

    public func finalizeAuthentication(_: NSURL) -> Bool {
        return false
    }

    public func isLinked() -> Bool {
        return false
    }

    public func unLink() {}

    public func saveFile(filename: String, data: NSData) -> Result<()> {
        return .error(NSError(domain: "UnconfiguredServiceError", code: 404, userInfo: .None))
    }

    public func getFiles() -> Result<[String]> {
        return .error(NSError(domain: "UnconfiguredServiceError", code: 404, userInfo: .None))
    }

    public func getFile(filename: String) -> Result<NSData> {
        return .error(NSError(domain: "UnconfiguredServiceError", code: 404, userInfo: .None))
    }
}
