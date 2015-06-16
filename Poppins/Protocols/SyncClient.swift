import ReactiveCocoa

protocol SyncClient {
    func getFiles() -> Signal<[FileInfo]>
    func getFile(path: String, destinationPath: String) -> SignalProducer<String, NSError>
    func getShareURL(path: String) -> SignalProducer<String, NSError>
    func uploadFile(filename: String, localPath: String) -> Signal<Void>
}
