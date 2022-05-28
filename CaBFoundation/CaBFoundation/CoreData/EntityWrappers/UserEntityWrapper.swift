import CoreData

public final class UserEntityWrapper: EntityWrapper {

    // MARK: - Public Properties

    public var id: String {
        get {
            return entityObject.value(forKey: "id") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "id")
        }
    }

    public var email: String {
        get {
            return entityObject.value(forKey: "email") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "email")
        }
    }

    public var password: String {
        get {
            return entityObject.value(forKey: "password") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "password")
        }
    }

    public var medicineItems: NSMutableArray {
        get {
            let predicate = NSPredicate(format: "user = %@", entityObject)
            return coreDataAssistant.loadData("MedicineItem", predicate: predicate, sortDescriptor: nil) ?? []
        }
        set {
            let predicate = NSPredicate(format: "user = %@", entityObject)
            coreDataAssistant.removeData("MedicineItem", predicate: predicate, sortDescriptor: nil)
            let array: [NSManagedObject] = newValue.compactMap { $0 as? NSManagedObject }
            entityObject.setValue(NSSet(array: array), forKey: "medicineItems")
        }
    }

    // MARK: - Private Properties

    private let coreDataAssistant: CoreDataAssistant
    private let entityObject: NSManagedObject

    // MARK: - Init

    public init(entityObject: NSManagedObject, coreDataAssistant: CoreDataAssistant) {
        self.entityObject = entityObject
        self.coreDataAssistant = coreDataAssistant
    }
    
    public init?(coreDataAssistant: CoreDataAssistant) {
        self.coreDataAssistant = coreDataAssistant

        let fetchResults = coreDataAssistant.loadData("User", predicate: nil, sortDescriptor: nil)

        guard let entityObject = fetchResults?.firstObject as? NSManagedObject else {
            logError(message: "Failed to fetch User entity")
            return nil
        }

        self.entityObject = entityObject
    }

}
