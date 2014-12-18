@IBDesignable
class Button: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}

extension Button {
    override func prepareForInterfaceBuilder() {
        layer.cornerRadius = cornerRadius
    }
}
