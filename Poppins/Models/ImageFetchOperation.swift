import Foundation
import Gifu
import Runes

class ImageFetchOperation: NSOperation {
    let size: CGSize
    let path: String
    let manager: SyncManager
    let callback: [AnimatedFrame] -> ()

    init(size: CGSize, path: String, manager: SyncManager, callback: [AnimatedFrame] -> ()) {
        self.size = size
        self.path = path
        self.manager = manager
        self.callback = callback
    }

    override func main() {
        if cancelled { return }
        let image = curry(AnimatedFrame.createWithData)
                <^> manager.getFile(path).value
                <*> size

        if cancelled { return }
        callback <^> image
    }
}
