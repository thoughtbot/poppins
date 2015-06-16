import Foundation
import Result
import Runes
import ReactiveCocoa

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

//        let producers = creatable.map { SignalProducer<FileInfo, NSError>(value: $0) }
        SignalProducer<FileInfo, NSError>(values: creatable)
            |> flatMap(.Merge, createFile)
            |> flatMap(.Merge, getFile)
            |> flatMap(.Merge, getShareURL)
            |> start(next: saveFile)
//        updatable.map(syncFile)
//        deletable.map(deleteFile)
    }

    private func getFile(cachedImage: CachedImage) -> SignalProducer<CachedImage, NSError> {
        println("get file: \(cachedImage.path)")
        return client.getFile(cachedImage.path, destinationPath: cachedImage.documentDirectoryPath)
            |> flatMap(.Merge, { _ in SignalProducer(value: cachedImage) })
    }

    private func getShareURL(cachedImage: CachedImage) -> SignalProducer<CachedImage, NSError> {
        println("get share url: \(cachedImage.path)")
        return client.getShareURL(cachedImage.path)
            |> on(next: { cachedImage.shareURLPath = $0 })
            |> flatMap(.Merge, { _ in SignalProducer(value: cachedImage) })
    }

    private func createFile(fileInfo: FileInfo) -> SignalProducer<CachedImage, NSError> {
        return SignalProducer { sink, _ in
            println("create: \(fileInfo.path)")
            let cachedImage = self.store.newCachedImage()
            cachedImage?.path = fileInfo.path
            cachedImage?.rev = fileInfo.rev
            curry(sendNext)(sink) <^> cachedImage
//            sendCompleted(sink)
        }
    }

    private func saveFile(cachedImage: CachedImage) {
        println("save: \(cachedImage.path)")
        store.saveCachedImage(cachedImage)
    }

    private func syncFile(cachedImage: CachedImage) {
        var semaphore = dispatch_semaphore_create(0)

        dispatch_to_main {
            _ = self.client.getFile(cachedImage.path, destinationPath: cachedImage.documentDirectoryPath)
                |> flatMap(.Merge, self.fillCachedImage(cachedImage))
                |> flatMap(.Merge, { self.client.getShareURL($0) })
                |> on(next: { cachedImage.shareURLPath = $0 })
                |> start(completed: {
                    self.store.saveCachedImage(cachedImage)
                    dispatch_semaphore_signal(semaphore)
                })
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }

    private func fillCachedImage(cachedImage: CachedImage)(path: String) -> SignalProducer<String, NSError> {
        return SignalProducer { sink, _ in
//            dispatch_to_user_initiated {
            println("fill aspect: \(cachedImage.path)")
                let data = NSData(contentsOfFile: path)
                let image = data >>- imageForData
                let aspectRatio = Double(image?.aspectRatio ?? 1.0)
                cachedImage.aspectRatio = aspectRatio
                sendNext(sink, cachedImage.path)
//                sendCompleted(sink)
//            }
        }
    }

    private func deleteFile(cachedImage: CachedImage) {
        store.deleteCachedImage(cachedImage)
    }
}
