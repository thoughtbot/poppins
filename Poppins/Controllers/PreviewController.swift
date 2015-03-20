import Foundation

class PreviewController {
    let path: String
    let size: CGSize
    var observer: ViewModelObserver?
    var data = NSData()

    var viewModel: PreviewViewModel {
        return PreviewViewModel(gifData: data)
    }

    init(path: String, size: CGSize) {
        self.path = path
        self.size = size
    }

    func loadData() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            if let d = NSData(contentsOfFile: self.path) {
                self.data = d
                dispatch_async(dispatch_get_main_queue()) { _ = self.observer?.viewModelDidChange() }
            }
        }
    }
}
