public class DropboxService : SyncableService {
    public let type: Service = .Dropbox

    public func setup() {
        let manager = DBAccountManager(appKey: "***REMOVED***", secret: "***REMOVED***")
        DBAccountManager.setSharedManager(manager)

        if isLinked() {
            DBAccountManager.sharedManager().linkedAccount >>- setupFilesystem
        }
    }

    public func initiateAuthentication<A>(controller: A) {
        controller as? UIViewController >>- DBAccountManager.sharedManager().linkFromController
    }

    public func finalizeAuthentication(url: NSURL) -> Bool {
        let account = DBAccountManager.sharedManager().handleOpenURL(url)
        account >>- setupFilesystem
        return account != .None
    }

    public func isLinked() -> Bool {
        return DBAccountManager.sharedManager().linkedAccount != .None
    }

    public func unLink() {
        DBAccountManager.sharedManager().linkedAccount?.unlink()
    }

    public func saveFile(filename: String, data: NSData) -> Result<()> {
        let path = DBPath.root().childPath(filename)
        return DBFilesystem.sharedFilesystem().createFile(path) >>- { $0.writeData(data) }
    }

    public func getFiles() -> Result<[String]> {
        let result = DBFilesystem.sharedFilesystem().listFolder(DBPath.root())
        let filePaths: [DBFileInfo] -> [String] = { $0.map { $0.path.stringValue() } }
        return filePaths <^> result
    }

    public func getFile(filename: String) -> Result<NSData> {
        let path = DBPath.root().childPath(filename)
        return DBFilesystem.sharedFilesystem().openFile(path) >>- { $0.readData() }
    }

    private func setupFilesystem(account: DBAccount) {
        DBFilesystem(account: account) >>- DBFilesystem.setSharedFilesystem
        DBFilesystem.sharedFilesystem().addObserver(self, forPathAndChildren: DBPath.root()) {
            NSNotificationCenter.defaultCenter().postNotificationName(FilesUpdatedNotificationName, object: .None)
        }
    }
}
