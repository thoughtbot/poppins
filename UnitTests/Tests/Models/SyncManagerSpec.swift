import Quick
import Nimble
import Poppins

class SyncManagerSpec: QuickSpec {
    override func spec() {
        describe("SyncManagerSpec") {
            describe("type") {
                it("should return the type of the given service") {
                    let manager = SyncManager(service: UnconfiguredService())
                    expect(manager.type).to(equal(Service.Unconfigured))
                }
            }

            describe("setService") {
                it("should change the service") {
                    let manager = SyncManager(service: FakeDropboxService())
                    expect(manager.type).to(equal(Service.Dropbox))
                }
            }

            describe("setup") {
                it("should call setup on the service") {
                    let fake = FakeDropboxService()
                    let manager = SyncManager(service: fake)
                    manager.setup()
                    expect(fake.lastCall).to(equal("setup"))
                }
            }

            describe("connect") {
                it("should call connect on the service") {
                    let vc = UIViewController()
                    let fake = FakeDropboxService()
                    let manager = SyncManager(service: fake)
                    manager.initiateAuthentication(vc)
                    expect(fake.lastCall).to(equal("connect"))
                    expect(fake.controller).to(equal(vc))
                }
            }

            describe("handleURL") {
                it("should call handleURL on the service") {
                    let url = NSURL(string: "http://test.com")
                    let fake = FakeDropboxService()
                    let manager = SyncManager(service: fake)
                    manager.finalizeAuthentication(url!)
                    expect(fake.lastCall).to(equal("handleURL"))
                    expect(fake.url).to(equal(url))
                }

                context("can handle url") {
                    it("should post a notification") {
                        let url = NSURL(string: "http://test.com")
                        let fake = FakeDropboxService()
                        let notificationListener = NotificationListener(notificationName: AccountLinkedNotificationName)

                        let manager = SyncManager(service: fake)
                        manager.finalizeAuthentication(url!)
                        expect(notificationListener.fired).toEventually(beTruthy())
                    }
                }
            }

            describe("isLinked") {
                it("should call isLinked on the service") {
                    let fake = FakeDropboxService()
                    let manager = SyncManager(service: fake)
                    let status = manager.isLinked()
                    expect(fake.lastCall).to(equal("isLinked"))
                    expect(status).to(beFalsy())
                }
            }

            describe("unlink") {
                it("should call unlink on the service") {
                    let fake = FakeDropboxService()
                    let manager = SyncManager(service: fake)
                    manager.unLink()
                    expect(fake.lastCall).to(equal("unlink"))
                }
            }

            describe("saveFile") {
                it("should call saveFile on the service") {
                    let filename = "thefile.gif"
                    let data = NSData()
                    let fake = FakeDropboxService()
                    let manager = SyncManager(service: fake)
                    manager.saveFile(filename, data: data)
                    expect(fake.lastCall).to(equal("saveFile"))
                    expect(fake.filename).to(equal(filename))
                    expect(fake.data).to(equal(data))
                }
            }

            describe("getFile") {
                it("should call getFile on the service") {
                    let filename = "thefile.gif"
                    let fake = FakeDropboxService()
                    let manager = SyncManager(service: fake)
                    manager.getFile(filename)
                    expect(fake.lastCall).to(equal("getFile"))
                    expect(fake.filename).to(equal(filename))
                }
            }

            describe("getFiles") {
                it("should call getFiles on the service") {
                    let fake = FakeDropboxService()
                    let manager = SyncManager(service: fake)
                    manager.getFiles()
                    expect(fake.lastCall).to(equal("getFiles"))
                }
            }
        }
    }
}
