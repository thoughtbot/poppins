import Foundation
import CoreData
import Runes

class Store {
    private let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)

    private var objectModel: NSManagedObjectModel? {
        let modelURL = NSBundle.mainBundle().URLForResource("PoppinsModel", withExtension: "momd")
        return modelURL >>- { NSManagedObjectModel(contentsOfURL: $0) }
    }

    var applicationDocumentDirectory: NSURL? {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last as NSURL?
    }

    init() {
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
            <^> objectModel
            <*> (applicationDocumentDirectory >>- appendSQLlitePathURL)
    }

    private func appendSQLlitePathURL(url: NSURL) -> NSURL? {
        return url.URLByAppendingPathComponent("PoppinsModel.sqlite")
    }

    private func persistentStoreCoordinator(objectModel: NSManagedObjectModel)(storeURL: NSURL) -> NSPersistentStoreCoordinator {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        let options = [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true
        ]
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: .None, URL: storeURL, options: options)
        } catch {}
        return persistentStoreCoordinator
    }

    func newObject<A: NSManagedObject>(objectName: String) -> A? {
        let desc = NSEntityDescription.entityForName(objectName, inManagedObjectContext: managedObjectContext)
        return desc.map { A(entity: $0, insertIntoManagedObjectContext: .None) }
    }

    func executeRequest<A: NSManagedObject>(request: NSFetchRequest) -> [A]? {
        return transform(managedObjectContext.executeFetchRequest)(request) as? [A]
    }

    func insertObject<A: NSManagedObject>(object: A) {
        managedObjectContext.performBlockAndWait {
            self.managedObjectContext.insertObject(object)
        }
    }

    func deleteObject<A: NSManagedObject>(object: A) {
        managedObjectContext.performBlockAndWait {
            self.managedObjectContext.deleteObject(object)
        }
    }

    func save() {
        managedObjectContext.performBlockAndWait {
            _ = transform(self.managedObjectContext.save)();
        }
    }

    var managedObjectContextObserver: ManagedObjectContextObserver {
        return ManagedObjectContextObserver(managedObjectContext: managedObjectContext)
    }
}
