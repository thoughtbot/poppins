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
            let yTotal = CGRectGetMidY(view.frame) * 2
            let yOffset = CGRectGetMaxY(view.frame) - ((yTotal - size.height) - 20)
            let newFrame = CGRect(origin: CGPoint(x: view.frame.origin.x, y: view.frame.origin.y - yOffset), size: view.frame.size)

            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
                self.view.frame = newFrame
            }, completion: .None)
        }
    }

    @IBAction func save() {
        // add image to core data
        // upload image to dropbox
    }

    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: .None)
    }
}

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
    static func create() -> ImportViewController {
        return ImportViewController(nibName: "ImportView", bundle: .None)
    }
}
