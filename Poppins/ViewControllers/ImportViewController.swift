import UIKit
import Gifu

class ImportViewController: UIViewController {
    @IBOutlet weak var imageView: AnimatableImageView!
    @IBOutlet weak var imageNameField: UITextField!
    @IBOutlet weak var extensionPicker: UIPickerView!

    var controller: ImportController?
    var importViewDidDismiss: (() -> ())?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func setup() {
        modalPresentationStyle = .Custom
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 4;
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: .None)

        guard let viewModel = controller?.viewModel else { return }
        imageView.animateWithImageData(viewModel.imageData)
        imageView.startAnimatingGIF()
        setImageType(viewModel.imageType)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let size = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size,
              let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return }

        let yTotal = view.superview?.frame.height ?? 0
        let yOffset = CGRectGetMaxY(view.frame) - (yTotal - (size.height + 20))
        let newFrame = CGRect(origin: CGPoint(x: view.frame.origin.x, y: view.frame.origin.y - yOffset), size: view.frame.size)

        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
            self.view.frame = newFrame
        }, completion: .None)
    }

    @IBAction func save() {
        guard let image = imageView.image else { return }

        let row = extensionPicker.selectedRowInComponent(ImportViewPickerDefaultComponent)
        let ext = pickerView(extensionPicker, titleForRow: row, forComponent: ImportViewPickerDefaultComponent)
        controller?.saveAndUploadImage(image, name: "\(imageNameField.text)\(ext)")
        dismissViewControllerAnimated(true, completion: importViewDidDismiss)
    }

    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: importViewDidDismiss)
    }
}

private let ImportViewPickerDefaultComponent = 0
extension ImportViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}

extension ImportViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0: return ".gif"
        case 1: return ".png"
        case 2: return ".jpeg"
        default: return ""
        }
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label
    }
}

extension ImportViewController {
    func setImageType(type: String) {
        let row: Int
        switch type {
        case JPEGType: row = 1
        case PNGType: row = 2
        default: row = 0
        }
        extensionPicker.selectRow(row, inComponent: ImportViewPickerDefaultComponent, animated: true)
    }
}

extension ImportViewController {
    static func create() -> ImportViewController {
        return ImportViewController(nibName: "ImportView", bundle: .None)
    }
}
