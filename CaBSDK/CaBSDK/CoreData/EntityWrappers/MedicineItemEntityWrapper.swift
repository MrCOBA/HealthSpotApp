import CoreData

public final class MedicineItemEntityWrapper {

    // MARK: - Public Properties

    public var id: Int16 {
        return entityObject.value(forKey: "id") as? Int16 ?? -1
    }

    public var name: String {
        return entityObject.value(forKey: "name") as? String ?? ""
    }

    public var barcode: String {
        return entityObject.value(forKey: "barcode") as? String ?? ""
    }

    public var marketUrlString: String {
        return entityObject.value(forKey: "marketUrl") as? String ?? ""
    }

    public var imageUrlString: String {
        return entityObject.value(forKey: "imageUrl") as? String ?? ""
    }

    public var producer: String {
        return entityObject.value(forKey: "producer") as? String ?? ""
    }

    public var activeComponent: String {
        return entityObject.value(forKey: "activeComponent") as? String ?? ""
    }

    public var periods: NSMutableArray? {
        let predicate = NSPredicate(format: "medicineItem = %@", entityObject)
        return coreDataAssistant.loadData("MedicineItemPeriod", predicate: predicate, sortDescriptor: nil)
    }

    public var User: NSManagedObject? {
        return entityObject.value(forKey: "user") as? NSManagedObject
    }

    // MARK: - Private properties

    private let coreDataAssistant: CoreDataAssistant
    private let entityObject: NSManagedObject

    // MARK: - Init

    public init(entityObject: NSManagedObject, coreDataAssistant: CoreDataAssistant) {
        self.entityObject = entityObject
        self.coreDataAssistant = coreDataAssistant
    }

    public init?(id: Int16, coreDataAssistant: CoreDataAssistant) {
        self.coreDataAssistant = coreDataAssistant

        let predicate = NSPredicate(format: "id = %@", id)
        let fetchResults = coreDataAssistant.loadData("MedicineItem", predicate: predicate, sortDescriptor: nil)

        guard let entityObject = fetchResults?.firstObject as? NSManagedObject else {
            logError(message: "Failed to fetch MedicineItem with id: <\(id)>")
            return nil
        }

        self.entityObject = entityObject
    }

}
