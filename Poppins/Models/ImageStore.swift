import CoreData

struct ImageStore {
    let store: Store

    func newCachedImage() -> CachedImage? {
        return store.newObject("CachedImage")
    }

    func cachedImageForPath(path: String) -> CachedImage? {
        let request = NSFetchRequest(entityName: "CachedImage")
        request.predicate = NSPredicate(format: "path = %@", path)
        return store.executeRequest(request)?.first as? CachedImage
    }

    func cachedImages() -> [CachedImage]? {
        let request = NSFetchRequest(entityName: "CachedImage")
        return store.executeRequest(request) as [CachedImage]?
    }

    func saveCachedImage(cachedImage: CachedImage) {
        store.insertObject(cachedImage)
        store.save()
    }

    func deleteCachedImage(cachedImage: CachedImage) {
        store.deleteObject(cachedImage)
        store.save()
    }
}
