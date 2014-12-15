import Gifu

class ImageCache: NSCache {
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didRecieveMemoryWarning"), name: UIApplicationDidReceiveMemoryWarningNotification, object: .None)
        name = "PoppinsImageCache"
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func didRecieveMemoryWarning() {
        removeAllObjects()
    }

    class func cachedImageForPath(path: String) -> AnimatedImage? {
        return sharedCache.objectForKey(path) as? AnimatedImage
    }

    class func cacheImage(image: AnimatedImage, forPath path: String) {
        sharedCache.setObject(image, forKey: path)
    }
}

private extension ImageCache {
    class var sharedCache: ImageCache {
        struct Static {
            static let instance = ImageCache()
        }

        return Static.instance
    }
}
