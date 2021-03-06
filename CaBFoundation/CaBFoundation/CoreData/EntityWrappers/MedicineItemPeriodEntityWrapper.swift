import CoreData

public final class MedicineItemPeriodEntityWrapper: EntityWrapper {

    // MARK: - Public Properties

    public var id: String {
        get {
            return entityObject.value(forKey: "id") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "id")
        }
    }

    public var startDate: Date {
        get {
            return entityObject.value(forKey: "startDate") as? Date ?? Date()
        }
        set {
            entityObject.setValue(newValue, forKey: "startDate")
        }
    }

    public var endDate: Date? {
        get {
            return entityObject.value(forKey: "endDate") as? Date
        }
        set {
            entityObject.setValue(newValue, forKey: "endDate")
        }
    }

    public var frequency: String {
        get {
            return entityObject.value(forKey: "frequency") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "frequency")
        }
    }

    public var notificationHint: String {
        get {
            return entityObject.value(forKey: "notificationHint") as? String ?? ""
        }
        set {
            entityObject.setValue(newValue, forKey: "notificationHint")
        }
    }

    public var medicineItem: NSManagedObject? {
        get {
            return entityObject.value(forKey: "medicineItem") as? NSManagedObject
        }
        set {
            entityObject.setValue(newValue, forKey: "medicineItem")
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
        let fetchResults = coreDataAssistant.loadData("MedicineItemPeriod", predicate: predicate, sortDescriptor: nil)

        guard let entityObject = fetchResults?.firstObject as? NSManagedObject else {
            logError(message: "Failed to fetch MedicineItemEntity with id: <\(id)>")
            return nil
        }

        self.entityObject = entityObject
    }

}
