struct UnconfiguredClient: SyncClient {
    func getFiles() -> Signal<[FileInfo]> {
        return Signal<[FileInfo]>()
    }

    func getFile(path: String, destinationPath: String) -> Signal<String> {
        return Signal<String>()
    }

    func getShareURL(path: String) -> Signal<String> {
        return Signal<String>()
    }
}
