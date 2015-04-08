import Foundation
import CoreData

@objc class ManagedObjectContextObserver {
    var callback: (([CachedImage], [CachedImage], [CachedImage]) -> ())? = .None

    init(managedObjectContext: NSManagedObjectContext) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidChange:", name: NSManagedObjectContextDidSaveNotification, object: managedObjectContext)
    }

    func contextDidChange(notification: NSNotification) {
        let insertsSet = notification.userInfo?[NSInsertedObjectsKey] as? NSSet
        let inserts = insertsSet?.allObjects as? [CachedImage] ?? []

        let updatesSet = notification.userInfo?[NSUpdatedObjectsKey] as? NSSet
        let updates = updatesSet?.allObjects as? [CachedImage] ?? []

        let deletesSet = notification.userInfo?[NSDeletedObjectsKey] as? NSSet
        let deletes = deletesSet?.allObjects as? [CachedImage] ?? []

        callback?(inserts, updates, deletes)
    }
}
