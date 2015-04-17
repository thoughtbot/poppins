import Foundation
import CoreData

@objc class CachedImage: NSManagedObject {
    @NSManaged var aspectRatio: Double
    @NSManaged var path: String
    @NSManaged var rev: String
    @NSManaged var shareURLPath: String
}
