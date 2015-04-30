struct ImportController {
    let imageData: NSData

    var viewModel: ImportViewModel {
        return ImportViewModel(imageData: imageData)
    }
}
