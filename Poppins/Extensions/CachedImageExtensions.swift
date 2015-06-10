import Foundation

extension CachedImage {
    var documentDirectoryPath: String {
        let documentDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String?
        return documentDir?.stringByAppendingPathComponent(path) ?? path
    }
}
