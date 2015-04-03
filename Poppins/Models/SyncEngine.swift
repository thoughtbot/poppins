import Foundation
import LlamaKit
import Runes

private let SupportedFileExtensions = ["gif", "png", "jpg", "jpeg"]

class SyncEngine {
    let store: ImageStore
    var client: SyncClient

    init(imageStore: ImageStore, syncClient: SyncClient) {
        store = imageStore
        client = syncClient
    }

    func runSync() {
        client.getFiles().observe { result in
            dispatch_to_user_initiated {
                let files = result.value?.filter {
                    contains(SupportedFileExtensions, $0.path.pathExtension.lowercaseString)
                }

                self.processFiles <^> files
            }
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
        var semaphore = dispatch_semaphore_create(0)

        dispatch_to_main {
            _ = self.client.getFile(cachedImage.path, destinationPath: cachedImage.documentDirectoryPath).observe { result in
                dispatch_to_user_initiated {
                    let data = result.value >>- { NSData(contentsOfFile: $0) }
                    let image = data >>- imageForData
                    let aspectRatio = Double(image?.aspectRatio ?? 1.0)
                    cachedImage.aspectRatio = aspectRatio
                    dispatch_to_main {
                        self.store.saveCachedImage(cachedImage)
                        dispatch_semaphore_signal(semaphore)
                    }
                }
            }
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }

    private func deleteFile(cachedImage: CachedImage) {
        store.deleteCachedImage(cachedImage)
    }
}
