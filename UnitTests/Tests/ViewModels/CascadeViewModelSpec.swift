import Quick
import Nimble

class CascadeViewModelSpec: QuickSpec {
    override func spec() {
        describe("CascadeViewModel") {
            describe("numberOfImages") {
                it("should return the count of the array") {
                    let manager = SyncManager(service: FakeDropboxService())
                    let viewModel = CascadeViewModel(manager: manager, images: ["test"])
                    expect(viewModel.numberOfImages).to(equal(1))
                }
            }

            describe("imagePathForIndexPath") {
                it("should return the string at the given index path") {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    let manager = SyncManager(service: FakeDropboxService())
                    let viewModel = CascadeViewModel(manager: manager, images: ["test"])

                    expect(viewModel.imagePathForIndexPath(indexPath)).to(equal("test"))
                }
            }

            describe("itemSizeForIndexPath") {
                it("should return the size of the image") {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    let manager = SyncManager(service: FakeDropboxService())
                    let viewModel = CascadeViewModel(manager: manager, images: ["test"])

                    expect(viewModel.imageSizeForIndexPath(indexPath)).to(equal(CGSize(width: 1, height: 1)))
                }
            }

            describe("gifItemSourceForIndexPath") {
                it("should return the item source with the data attached") {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    let manager = SyncManager(service: FakeDropboxService())
                    let viewModel = CascadeViewModel(manager: manager, images: ["test"])
                    let itemSource = viewModel.gifItemSourceForIndexPath(indexPath)

                    expect(itemSource?.imageData).to(equal(manager.getFile("").value))
                }
            }
        }
    }
}
