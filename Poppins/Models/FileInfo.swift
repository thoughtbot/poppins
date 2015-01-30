struct FileInfo {
    let path: String
    let rev: String
}

extension FileInfo {
    static func fromDropboxMetadata(metadata: DBMetadata) -> FileInfo {
        return FileInfo(path: metadata.path.lastPathComponent, rev: metadata.rev)
    }
}
