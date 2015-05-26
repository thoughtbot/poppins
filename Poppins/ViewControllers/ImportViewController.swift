import UIKit
import Gifu

class ImportViewController: UIViewController {
    @IBOutlet weak var imageView: AnimatableImageView!
    @IBOutlet weak var imageNameField: UITextField!
    @IBOutlet weak var extensionPicker: UIPickerView!

    var controller: ImportController?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    private func setup() {
        modalPresentationStyle = .Custom
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let viewModel = controller?.viewModel {
            imageView.animateWithImageData(data: viewModel.imageData)
            imageView.startAnimatingGIF()
            setImageType(viewModel.imageType)

        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: .None)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let size = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size,
           let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        {
            let yTotal = view.superview?.frame.height ?? 0
            let yOffset = CGRectGetMaxY(view.frame) - (yTotal - (size.height + 20))
            let newFrame = CGRect(origin: CGPoint(x: view.frame.origin.x, y: view.frame.origin.y - yOffset), size: view.frame.size)

            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
                self.view.frame = newFrame
            }, completion: .None)
        }
    }

    @IBAction func save() {
        if let image = imageView.image {
            let row = extensionPicker.selectedRowInComponent(ImportViewPickerDefaultComponent)
            let ext = pickerView(extensionPicker, titleForRow: row, forComponent: ImportViewPickerDefaultComponent)
            controller?.saveAndUploadImage(image, name: "\(imageNameField.text)\(ext)")
            dismissViewControllerAnimated(true, completion: .None)
        }
    }

    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: .None)
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
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch row {
        case 0: return ".gif"
        case 1: return ".png"
        case 2: return ".jpeg"
        default: return ""
        }
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
