extension DBFile {
    func writeData(data: NSData) -> Result<()> {
        var error: DBError?
        writeData(data, error: &error)

        switch error {
        case .None: return .success(())
        case let .Some(err): return .error(err)
        }
    }

    func readData() -> Result<NSData> {
        var error: DBError?
        let data = readData(&error)

        switch error {
        case .None: return .success(data)
        case let .Some(err): return .error(err)
        }
    }
}
