extension DBFilesystem {
    func createFile(path: DBPath) -> Result<DBFile> {
        var error: DBError?
        let file = createFile(path, error: &error)

        switch error {
        case .None: return .success(file)
        case let .Some(err): return .error(err)
        }
    }

    func openFile(path: DBPath) -> Result<DBFile> {
        var error: DBError?
        let file = openFile(path, error: &error)

        switch error {
        case .None: return .success(file)
        case let .Some(err): return .error(err)
        }
    }

    func listFolder(path: DBPath) -> Result<[DBFileInfo]> {
        var error: DBError?
        let files = listFolder(path, error: &error)

        switch error {
        case .None: return .success(files as [DBFileInfo])
        case let .Some(err): return .error(err)
        }
    }
}
