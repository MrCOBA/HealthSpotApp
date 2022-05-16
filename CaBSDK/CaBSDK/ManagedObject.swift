import CoreData

public protocol ManagedObject: NSManagedObject {

    static var entityName: String { get }

}
