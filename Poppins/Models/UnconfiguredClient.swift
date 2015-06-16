import ReactiveCocoa

struct UnconfiguredClient: SyncClient {
    func getFiles() -> Signal<[FileInfo]> {
        return Signal<[FileInfo]>()
    }

    func getFile(path: String, destinationPath: String) -> SignalProducer<String, NSError> {
        return SignalProducer<String, NSError>.never
    }

    func getShareURL(path: String) -> SignalProducer<String, NSError> {
        return SignalProducer<String, NSError>.never
    }

    func uploadFile(filename: String, localPath: String) -> Signal<Void> {
        return Signal<Void>()
    }
}
