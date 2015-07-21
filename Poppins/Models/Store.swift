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
        return urls.last as? NSURL
    }

    init(storeType: String = NSSQLiteStoreType) {
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
            <^> pure(storeType)
            <*> objectModel
            <*> (applicationDocumentDirectory >>- appendSQLlitePathURL)
    }

    private func appendSQLlitePathURL(url: NSURL) -> NSURL? {
        return url.URLByAppendingPathComponent("PoppinsModel.sqlite")
    }

    private func persistentStoreCoordinator(storeType: String)(objectModel: NSManagedObjectModel)(storeURL: NSURL) -> NSPersistentStoreCoordinator {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        let options = [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true
        ]
        persistentStoreCoordinator.addPersistentStoreWithType(storeType, configuration: .None, URL: storeURL, options: options, error: nil)
        return persistentStoreCoordinator
    }

    func newObject<A: NSManagedObject>(objectName: String) -> A? {
        let desc = NSEntityDescription.entityForName(objectName, inManagedObjectContext: managedObjectContext)
        return desc.map { A(entity: $0, insertIntoManagedObjectContext: .None) }
    }

    func executeRequest<A: NSManagedObject>(request: NSFetchRequest) -> [A]? {
        return managedObjectContext.executeFetchRequest(request, error: nil) as? [A]
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
            _ = self.managedObjectContext.save(nil);
        }
    }

    var managedObjectContextObserver: ManagedObjectContextObserver {
        return ManagedObjectContextObserver(managedObjectContext: managedObjectContext)
    }
}
