import Runes

class DropboxService : LinkableService {
    let type: Service = .Dropbox
    var client: SyncClient {
        return DropboxClient(session: DBSession.sharedSession())
    }

    func setup() {
        let session = DBSession(appKey: Keys.dropboxKey, appSecret: Keys.dropboxSecret, root: kDBRootAppFolder)
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
