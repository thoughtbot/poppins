import Runes

class DropboxService : LinkableService {
    let type: Service = .Dropbox

    func setup() {
        let session = DBSession(appKey: "j77mzt1vvjloikh", secret: "y3rw9dlmd72dkr3", root:kDBRootAppFolder)
        DBSession.setSharedSession(session)
    }

    func initiateAuthentication<T>(controller: T) {
        DBSession.sharedSession().linkFromController <^> controller as? UIViewController
    }

    func finalizeAuthentication(url: NSURL) -> Bool {
        let account = DBSession.sharedSession().handleOpenURL(url)
        return account != .None
    }

    func isLinked() -> Bool {
        return DBSession.sharedSession().isLinked()
    }

    func unLink() {
        DBSession.sharedSession().unlinkAll()
    }
}
