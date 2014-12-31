import Poppins
import LlamaKit

class FakeDropboxService: SyncableService {
    var lastCall: String = ""
    var controller: UIViewController?
    var url: NSURL?
    var filename: String?
    var data: NSData?

    let type: Service = .Dropbox

    init() {}

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

    func saveFile(filename: String, data: NSData) -> Result<()> {
        lastCall = "saveFile"
        self.filename = filename
        self.data = data
        return success(())
    }

    func getFiles() -> Result<[String]> {
        lastCall = "getFiles"
        return success([])
    }

    func getFile(filename: String) -> Result<NSData> {
        lastCall = "getFile"
        self.filename = filename
        return success(NSData())
    }
}
