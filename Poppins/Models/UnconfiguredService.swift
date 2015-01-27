import LlamaKit

class UnconfiguredService: SyncableService {
    let type: Service = .Unconfigured
    var observer: ServiceUpdateObserver? = .None

    func setup() {}

    func initiateAuthentication<T>(_: T) {}

    func finalizeAuthentication(_: NSURL) -> Bool {
        return false
    }

    func isLinked() -> Bool {
        return false
    }

    func unLink() {}

    func saveFile(filename: String, data: NSData) -> Result<(), NSError> {
        return failure(NSError(domain: "UnconfiguredServiceError", code: 404, userInfo: .None))
    }

    func getFiles() -> Result<[String], NSError> {
        return failure(NSError(domain: "UnconfiguredServiceError", code: 404, userInfo: .None))
    }

    func getFile(filename: String) -> Result<NSData, NSError> {
        return failure(NSError(domain: "UnconfiguredServiceError", code: 404, userInfo: .None))
    }
}
