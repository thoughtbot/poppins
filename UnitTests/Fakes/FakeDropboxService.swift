import Poppins
import LlamaKit

class FakeDropboxService: SyncableService {
    var lastCall: String = ""
    var controller: UIViewController?
    var url: NSURL?
    var filename: String?
    var data: NSData?
    var observer: ServiceUpdateObserver?

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

    func saveFile(filename: String, data: NSData) -> Result<(), NSError> {
        lastCall = "saveFile"
        self.filename = filename
        self.data = data
        return success(())
    }

    func getFiles() -> Result<[String], NSError> {
        lastCall = "getFiles"
        return success([])
    }

    func getFile(filename: String) -> Result<NSData, NSError> {
        lastCall = "getFile"
        self.filename = filename

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return success(UIImagePNGRepresentation(image))
    }
}
