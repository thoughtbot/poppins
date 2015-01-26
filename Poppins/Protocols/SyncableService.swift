import LlamaKit

public protocol SyncableService {
    var type: Service { get }

    func setup()
    func initiateAuthentication<T>(T)
    func finalizeAuthentication(NSURL) -> Bool
    func isLinked() -> Bool
    func unLink()

    func saveFile(filename: String, data: NSData) -> Result<(), NSError>
    func getFiles() -> Result<[String], NSError>
    func getFile(path: String) -> Result<NSData, NSError>
}
