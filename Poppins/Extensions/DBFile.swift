import LlamaKit

extension DBFile {
    func writeData(data: NSData) -> Result<(), NSError> {
        var error: DBError?
        writeData(data, error: &error)

        switch error {
        case .None: return success(())
        case let .Some(err): return failure(err)
        }
    }

    func readData() -> Result<NSData, NSError> {
        var error: DBError?
        let data = readData(&error)

        switch error {
        case .None: return success(data)
        case let .Some(err): return failure(err)
        }
    }
}
