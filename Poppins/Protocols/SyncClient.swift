protocol SyncClient {
    func getFiles() -> Signal<[FileInfo]>
    func getFile(path: String, destinationPath: String) -> Signal<String>
    func getShareURL(path: String) -> Signal<String>
}
