import LlamaKit

public let AccountLinkedNotificationName = "PoppinsAccountLinked"
let PreloadCompletedNotificationName = "PoppinsPreloadCompleted"
let InitialSyncCompletedNotificationName = "PoppinsInitialSyncCompleted"

public let ServiceKey = "PoppinsService"

public class SyncManager: SyncableService {
    public var service: SyncableService
    public var type: Service {
        return service.type
    }

    public class var sharedManager: SyncManager {
        struct Static {
            static let instance: SyncManager = SyncManager(service: UnconfiguredService())
        }
        return Static.instance
    }

    init(service: SyncableService) {
        self.service = service
    }

    public func setService(service: SyncableService) {
        self.service = service
    }

    public func initiateAuthentication<T>(meta: T) {
        service.initiateAuthentication(meta)
    }

    public func finalizeAuthentication(url: NSURL) -> Bool {
        let handled = service.finalizeAuthentication(url)
        if handled {
            NSNotificationCenter.defaultCenter().postNotificationName(AccountLinkedNotificationName, object: .None)
        }
        return handled
    }

    public func setup() {
        service.setup()
    }

    public func isLinked() -> Bool {
        return service.isLinked()
    }

    public func unLink() {
        service.unLink()
    }

    public func saveFile(filename: String, data: NSData) -> Result<(), NSError> {
        return service.saveFile(filename, data: data)
    }

    public func getFile(path: String) -> Result<NSData, NSError> {
        return service.getFile(path)
    }

    public func getFiles() -> Result<[String], NSError> {
        return service.getFiles()
    }

    func preload(files: [String]) {
        Async.map(files, self.getFile).done {
            NSNotificationCenter.defaultCenter().postNotificationName(PreloadCompletedNotificationName, object: .None)
        }
    }
}
