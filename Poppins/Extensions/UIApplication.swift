extension UIApplication {
    func isUnitTesting() -> Bool {
        let info = NSProcessInfo.processInfo().environment
        let injectBundlePath = info["XCInjectBundle"] as String?
        let isUnitTesting = injectBundlePath?.pathExtension == "xctest"
        return isUnitTesting
    }
}
