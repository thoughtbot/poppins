extension CGRect {
    func centeredRectForSize(size: CGSize) -> CGRect {
        let x = CGRectGetMidX(self) - size.width / 2
        let y = CGRectGetMidY(self) - size.height / 2
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }

    func centeredRectForSize(size: CGSize, offset: CGPoint) -> CGRect {
        let centeredRect = centeredRectForSize(size)
        let x = centeredRect.origin.x - offset.x
        let y = centeredRect.origin.y - offset.y
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
}
