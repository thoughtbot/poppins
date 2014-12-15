import Gifu

class PoppinsCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func configureWithImageData(data: NSData) {
        let size = imageSizeConstrainedByWidth(frame.width) <^> UIImage(data: data) ?? CGSizeZero
        let image = AnimatedImage(data: data, size: size)
        imageView.setAnimatedImage(image)
        imageView.startAnimatingGIF()
    }
}
