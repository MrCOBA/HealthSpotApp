import CoreData

public final class MedicineItemEntityWrapper: EntityWrapper {

    // MARK: - Public Properties

    public var id: String {
        get {
            return entityObject.value(forKey: "id") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "id")
        }
    }

    public var name: String {
        get {
            return entityObject.value(forKey: "name") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "name")
        }
    }

    public var barcode: String {
        get {
            return entityObject.value(forKey: "barcode") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "barcode")
        }
    }

    public var marketUrlString: String {
        get {
            return entityObject.value(forKey: "marketUrl") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "marketUrl")
        }
    }

    public var imageUrlString: String {
        get {
            return entityObject.value(forKey: "imageUrl") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "imageUrl")
        }
    }

    public var producer: String {
        get {
            return entityObject.value(forKey: "producer") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "producer")
        }
    }

    public var activeComponent: String {
        get {
            return entityObject.value(forKey: "activeComponent") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "activeComponent")
        }
    }

    public var periods: NSMutableArray {
        get {
            let predicate = NSPredicate(format: "medicineItem = %@", entityObject)
            return coreDataAssistant.loadData("MedicineItemPeriod", predicate: predicate, sortDescriptor: nil) ?? []
        }
        set {
            let predicate = NSPredicate(format: "medicineItem = %@", entityObject)
            coreDataAssistant.removeData("MedicineItemPeriod", predicate: predicate, sortDescriptor: nil)
            let array: [NSManagedObject] = newValue.compactMap { $0 as? NSManagedObject }
            entityObject.setValue(NSSet(array: array), forKey: "periods")
        }
    }

    public var User: NSManagedObject? {
        get {
            return entityObject.value(forKey: "user") as? NSManagedObject
        }
        set {
            entityObject.setValue(newValue, forKey: "user")
        }
    }

    // MARK: - Private properties

    private let coreDataAssistant: CoreDataAssistant
    private let entityObject: NSManagedObject

    // MARK: - Init

    public init(entityObject: NSManagedObject, coreDataAssistant: CoreDataAssistant) {
        self.entityObject = entityObject
        self.coreDataAssistant = coreDataAssistant
    }

    public init?(id: String, coreDataAssistant: CoreDataAssistant) {
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
