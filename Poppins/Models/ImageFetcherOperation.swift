import Foundation
import Runes

class ImageFetcherOperation: NSOperation {
    let path: String
    let size: CGSize
    let callback: UIImage -> ()

    init(path: String, size: CGSize, callback: UIImage -> ()) {
        self.path = path
        self.size = size
        self.callback = callback
        super.init()
    }

    override func main() {
        let data = NSData(contentsOfFile: path)
        let image = data >>- imageForData
        let scaledImage = image?.imageForSize(size)
        
        callback <^> scaledImage
    }
}
