import Gifu

class PoppinsCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func configureWithImageData(data: NSData) {
        let size = UIImage(data: data) >>- imageSizeConstrainedByWidth(frame.width) ?? CGSizeZero
        let image = AnimatedImage(data: data, size: size)
        imageView.setAnimatedImage(image)
        imageView.startAnimatingGIF()
    }
}
