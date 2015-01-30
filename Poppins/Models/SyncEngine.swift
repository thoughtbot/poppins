import Foundation
import LlamaKit
import Runes

class SyncEngine {
    let store: ImageStore
    var client: SyncClient

    init(imageStore: ImageStore, syncClient: SyncClient) {
        store = imageStore
        client = syncClient
    }

    func runSync() {
        client.getFiles().observe {
            _ = self.processFiles <^> $0.value
        }
    }

    private func processFiles(fileInfos: [FileInfo]) {
        let cachedImages = store.cachedImages() ?? []

        let updatable: [CachedImage] = cachedImages.reduce([]) { accum, image in
            if let index = find(fileInfos.map { $0.path }, image.path) {
                if fileInfos[index].rev != image.rev {
                    image.rev = fileInfos[index].rev
                    return accum + [image]
                }
            }
            return accum
        }

        let creatable = fileInfos.filter { info in
            return find(cachedImages.map { $0.path }, info.path) == .None
        }

        let deletable = cachedImages.filter { image in
            return find(fileInfos.map { $0.path }, image.path) == .None
        }

        creatable.map(createFile)
        updatable.map(syncFile)
        deletable.map(deleteFile)
    }

    private func createFile(fileInfo: FileInfo) {
        let cachedImage = store.newCachedImage()
        cachedImage?.path = fileInfo.path
        cachedImage?.rev = fileInfo.rev
        syncFile <^> cachedImage
    }

    private func syncFile(cachedImage: CachedImage) {
        client.getFile(cachedImage.path, destinationPath: cachedImage.documentDirectoryPath).observe {
            let data = $0.value >>- { NSData(contentsOfFile: $0) }
            let image = data >>- imageForData
            let aspectRatio = Double(image?.aspectRatio ?? 1.0)
            cachedImage.aspectRatio = aspectRatio
            self.store.saveCachedImage(cachedImage)
        }
    }

    private func deleteFile(cachedImage: CachedImage) {
        cachedImage.delete(.None)
    }
}
