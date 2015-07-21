import Quick
import Nimble
import CoreData

class CascadeViewModelSpec: QuickSpec {
    override func spec() {
        describe("CascadeViewModel") {
            describe("numberOfImages") {
                it("should return the count of the array") {
                    let store = Store(storeType: NSInMemoryStoreType)
                    let cachedImage: CachedImage? = store.newObject("CachedImage")
                    let viewModel = CascadeViewModel(images: [cachedImage!])
                    expect(viewModel.numberOfImages).to(equal(1))
                }
            }

            describe("imagePathForIndexPath") {
                it("should return the string at the given index path") {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    let store = Store(storeType: NSInMemoryStoreType)
                    let cachedImage: CachedImage? = store.newObject("CachedImage")
                    cachedImage?.path = "my/path"
                    let viewModel = CascadeViewModel(images: [cachedImage!])

                    expect(viewModel.imagePathForIndexPath(indexPath)).to(endWith("my/path"))
                }
            }

            describe("itemSizeForIndexPath") {
                it("should return the size of the image") {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    let store = Store(storeType: NSInMemoryStoreType)
                    let cachedImage: CachedImage? = store.newObject("CachedImage")
                    cachedImage?.aspectRatio = 0.5
                    let viewModel = CascadeViewModel(images: [cachedImage!])

                    expect(viewModel.imageSizeForIndexPath(indexPath)).to(equal(CGSize(width: 1, height: 0.5)))
                }
            }
        }
    }
}
