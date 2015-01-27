import LlamaKit
import Runes

public let AccountLinkedNotificationName = "PoppinsAccountLinked"
let PreloadCompletedNotificationName = "PoppinsPreloadCompleted"
let InitialSyncCompletedNotificationName = "PoppinsInitialSyncCompleted"

let ServiceKey = "PoppinsService"

class SyncManager: SyncableService, ServiceUpdateObserver {
    var observer: ServiceUpdateObserver?

    var service: SyncableService {
        didSet {
            service.observer = self
        }
    }

    var type: Service {
        return service.type
    }

    init(service: SyncableService) {
        self.service = service
    }

    func setService(service: SyncableService) {
        self.service = service
    }

    func initiateAuthentication<T>(meta: T) {
        service.initiateAuthentication(meta)
    }

    func finalizeAuthentication(url: NSURL) -> Bool {
        let handled = service.finalizeAuthentication(url)
        if handled {
            NSNotificationCenter.defaultCenter().postNotificationName(AccountLinkedNotificationName, object: .None)
        }
        return handled
    }

    func setup() {
        service.setup()
    }

    func isLinked() -> Bool {
        return service.isLinked()
    }

    func unLink() {
        service.unLink()
    }

    func saveFile(filename: String, data: NSData) -> Result<(), NSError> {
        return service.saveFile(filename, data: data)
    }

    func getFile(path: String) -> Result<NSData, NSError> {
        return service.getFile(path)
    }

    func getFiles() -> Result<[String], NSError> {
        return service.getFiles()
    }

    func preload(files: [String]) {
        Async.map(files, self.getFile).done {
            NSNotificationCenter.defaultCenter().postNotificationName(PreloadCompletedNotificationName, object: .None)
        }
    }

    func serviceDidUpdate() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            _ = self.preload <^> self.getFiles()
        }
    }
}
