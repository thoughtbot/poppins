struct ImportController {
    let imageData: NSData
    let imageType: String
    let store: ImageStore
    let client: SyncClient

    var viewModel: ImportViewModel {
        return ImportViewModel(imageData: imageData, imageType: imageType)
    }

    func saveAndUploadImage(image: UIImage, name: String) {
        let path = store.saveImageData(imageData, name: name, aspectRatio: Double(image.aspectRatio))
        path.map { client.uploadFile(name, localPath: $0) }
    }
}
