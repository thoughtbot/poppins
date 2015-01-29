import LlamaKit
import Runes

let AccountLinkedNotificationName = "PoppinsAccountLinked"
let ServiceKey = "PoppinsService"

class LinkManager: LinkableService {
    var service: LinkableService

    var type: Service {
        return service.type
    }

    init(service: LinkableService) {
        self.service = service
    }

    func setService(service: LinkableService) {
        self.service = service
    }

    func initiateAuthentication<T>(meta: T) {
        service.initiateAuthentication(meta)
    }

    func finalizeAuthentication(url: NSURL) -> Bool {
        let handled = service.finalizeAuthentication(url)
        if handled {
            NSNotificationCenter.defaultCenter().postNotificationName(AccountLinkedNotificationName, object: .None)
        }
        return handled
    }

    func setup() {
        service.setup()
    }

    func isLinked() -> Bool {
        return service.isLinked()
    }

    func unLink() {
        service.unLink()
    }
}
