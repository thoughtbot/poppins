class LinkAccountViewController: UIViewController {
    var controller: LinkAccountController?

    @IBAction func linkDropbox() {
        controller?.linkAccount(self)
    }
}
