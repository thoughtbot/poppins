import LlamaKit

extension DBFilesystem {
    func createFile(path: DBPath) -> Result<DBFile, NSError> {
        var error: DBError?
        let file = createFile(path, error: &error)

        switch error {
        case .None: return success(file)
        case let .Some(err): return failure(err)
        }
    }

    func openFile(path: DBPath) -> Result<DBFile, NSError> {
        var error: DBError?
        let file = openFile(path, error: &error)

        switch error {
        case .None: return success(file)
        case let .Some(err): return failure(err)
        }
    }

    func listFolder(path: DBPath) -> Result<[DBFileInfo], NSError> {
        var error: DBError?
        let files = listFolder(path, error: &error)

        switch error {
        case .None: return success(files as [DBFileInfo])
        case let .Some(err): return failure(err)
        }
    }
}
