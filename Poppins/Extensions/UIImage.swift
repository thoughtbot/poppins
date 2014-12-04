extension UIImage {
    class func sizeForImageData(data: NSData) -> CGSize? {
        return UIImage(data: data)?.size
    }
}
