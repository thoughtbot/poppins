import Poppins
import Quick
import Nimble

class ArrayExtensionSpec: QuickSpec {
    override func spec() {
        describe("Array Extension") {
            describe("safeValue") {
                context("when accessing an existing index") {
                    it("should return the optional wrapped value") {
                        let items = ["hi", "bye"]
                        expect(safeValue(items, 1)).to(equal(.Some("bye")))
                    }
                }

                context("when accessing an out of bounds index") {
                    it("should return a .None value") {
                        let items = ["hi", "bye"]
                        expect(safeValue(items, 2)).to(beNil())
                        expect(safeValue(items, -1)).to(beNil())
                    }
                }
            }
        }
    }
}
