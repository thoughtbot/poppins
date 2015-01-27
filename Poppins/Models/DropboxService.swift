import LlamaKit
import Runes

class DropboxService : SyncableService {
    let type: Service = .Dropbox
    var observer: ServiceUpdateObserver? = .None

    func setup() {
        let manager = DBAccountManager(appKey: "***REMOVED***", secret: "***REMOVED***")
        DBAccountManager.setSharedManager(manager)

        if isLinked() {
            setupFilesystem <^> DBAccountManager.sharedManager().linkedAccount
        }
    }

    func initiateAuthentication<T>(controller: T) {
        DBAccountManager.sharedManager().linkFromController <^> controller as? UIViewController
    }

    func finalizeAuthentication(url: NSURL) -> Bool {
        let account = DBAccountManager.sharedManager().handleOpenURL(url)
        setupFilesystem <^> account
        return account != .None
    }

    func isLinked() -> Bool {
        return DBAccountManager.sharedManager().linkedAccount != .None
    }

    func unLink() {
        DBAccountManager.sharedManager().linkedAccount?.unlink()
    }

    func saveFile(filename: String, data: NSData) -> Result<(), NSError> {
        let path = DBPath.root().childPath(filename)
        return DBFilesystem.sharedFilesystem().createFile(path) >>- { $0.writeData(data) }
    }

    func getFiles() -> Result<[String], NSError> {
        let result = DBFilesystem.sharedFilesystem().listFolder(DBPath.root())
        let filePaths: [DBFileInfo] -> [String] = { $0.map { $0.path.stringValue() } }
        return filePaths <^> result
    }

    func getFile(filename: String) -> Result<NSData, NSError> {
        let path = DBPath.root().childPath(filename)
        return DBFilesystem.sharedFilesystem().openFile(path) >>- { file in
            let data = file.readData()
            file.close()
            return data
        }
    }

    private func setupFilesystem(account: DBAccount) {
        DBFilesystem.setSharedFilesystem <^> DBFilesystem(account: account)
        let filesystem = DBFilesystem.sharedFilesystem()

        watchForFileChanges()
        filesystem.addObserver(self) {
            if filesystem.completedFirstSync && !filesystem.status.metadata.inProgress {
                var token: dispatch_once_t = 0
                dispatch_once(&token, self.completePreload)
            }
        }
    }

    private func completePreload() {
        let filesystem = DBFilesystem.sharedFilesystem()
        filesystem.removeObserver(self)
        NSNotificationCenter.defaultCenter().postNotificationName(InitialSyncCompletedNotificationName, object: .None)
        watchForFileChanges()
    }

    private func watchForFileChanges() {
        DBFilesystem.sharedFilesystem().addObserver(self, forPathAndDescendants: DBPath.root()) {
            _ = self.observer?.serviceDidUpdate()
        }
    }
}
