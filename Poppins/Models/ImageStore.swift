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
        if !cachedImage.updated { store.insertObject(cachedImage) }
        store.save()
    }

    func deleteCachedImage(cachedImage: CachedImage) {
        store.deleteObject(cachedImage)
        store.save()
    }

    func saveImageData(data: NSData, name: String, aspectRatio: Double) -> String? {
        guard let cachedImage = newCachedImage() else { return .None }

        cachedImage.aspectRatio = aspectRatio
        cachedImage.path = name
        data.writeToFile(cachedImage.documentDirectoryPath, atomically: true)
        saveCachedImage(cachedImage)
        return cachedImage.documentDirectoryPath
    }
}
