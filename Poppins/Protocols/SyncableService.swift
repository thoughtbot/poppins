import LlamaKit

public protocol SyncableService {
    var type: Service { get }

    func setup()
    func initiateAuthentication<A>(A)
    func finalizeAuthentication(NSURL) -> Bool
    func isLinked() -> Bool
    func unLink()

    func saveFile(filename: String, data: NSData) -> Result<()>
    func getFiles() -> Result<[String]>
    func getFile(path: String) -> Result<NSData>
}
