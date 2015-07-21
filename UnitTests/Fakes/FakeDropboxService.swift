import Result

class FakeDropboxService: LinkableService {
    var lastCall: String = ""
    var controller: UIViewController?
    var url: NSURL?

    let type: Service = .Dropbox
    let client: SyncClient = FakeDropboxSyncClient()

    func setup() {
        lastCall = "setup"
    }

    func initiateAuthentication<A>(controller: A) {
        lastCall = "connect"
        self.controller = controller as? UIViewController
    }

    func finalizeAuthentication(url: NSURL) -> Bool {
        lastCall = "handleURL"
        self.url = url
        return true
    }

    func isLinked() -> Bool {
        lastCall = "isLinked"
        return false
    }

    func unLink() {
        lastCall = "unlink"
    }
}

class FakeDropboxSyncClient: SyncClient {
    var lastCall: String = ""

    func getFiles() -> Signal<[FileInfo]> {
        lastCall = "getFiles"
        return Signal()
    }

    func getFile(path: String, destinationPath: String) -> Signal<String> {
        lastCall = "getFile"
        return Signal()
    }

    func getShareURL(path: String) -> Signal<String> {
        lastCall = "getShareURL"
        return Signal()
    }

    func uploadFile(filename: String, localPath: String) -> Signal<Void> {
        lastCall = "uploadFile"
        return Signal()
    }
}
