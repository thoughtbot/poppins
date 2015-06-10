import Gifu

class Cache<T> {
    var cache: [String: T] = [:]

    func itemForKey(key: String) -> T? {
        return cache[key]
    }

    func setItem(item: T, forKey key: String) {
        cache[key] = item
    }

    func purge() {
        print("purging cache")
        cache = [:]
    }
}

@objc class CachePurger {
    let cache: Cache<UIImage>

    init(cache: Cache<UIImage>) {
        self.cache = cache
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didRecieveMemoryWarning"), name: UIApplicationDidReceiveMemoryWarningNotification, object: .None)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func didRecieveMemoryWarning() {
        cache.purge()
    }

}