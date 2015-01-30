import Foundation
import Runes
import ImageIO

class ImageFetchOperation: NSOperation {
    let size: CGSize
    let path: String
    let callback: UIImage? -> ()

    init(size: CGSize, path: String, callback: UIImage? -> ()) {
        self.size = size
        self.path = path
        self.callback = callback
    }

    override func main() {
        if cancelled { return }
        let data = NSData(contentsOfFile: path)

        if cancelled { return }
        let imageSource = data >>- { CGImageSourceCreateWithData($0, nil) }

        let options = [
            kCGImageSourceThumbnailMaxPixelSize as NSString: max(size.width, size.height) * 2,
            kCGImageSourceCreateThumbnailFromImageIfAbsent as NSString: true
        ]
        let scaledImage = imageSource >>- { UIImage(CGImage: CGImageSourceCreateThumbnailAtIndex($0, 0, options)) }

        if cancelled { return }
        callback(scaledImage)
    }
}
