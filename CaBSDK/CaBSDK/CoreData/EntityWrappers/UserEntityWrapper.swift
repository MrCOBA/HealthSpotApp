import CoreData

public final class UserEntityWrapper {

    // MARK: - Public Properties

    public var email: String {
        return entityObject.value(forKey: "email") as? String ?? ""
    }

    public var password: String {
        return entityObject.value(forKey: "password") as? String ?? ""
    }

    public var medicineItems: NSMutableArray? {
        let predicate = NSPredicate(format: "user = %@", entityObject)
        return coreDataAssistant.loadData("MedicineItem", predicate: predicate, sortDescriptor: nil)
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
