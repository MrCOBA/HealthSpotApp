import CoreData

public final class MedicineItemPeriodEntityWrapper {

    // MARK: - Public Properties

    public var id: Int16 {
        get {
            return entityObject.value(forKey: "id") as? Int16 ?? -1
        }
        set {
            entityObject.setValue(newValue, forKey: "id")
        }
    }

    public var startDate: Date {
        get {
            return entityObject.value(forKey: "startDate") as? Date
        }
        set {
            entityObject.setValue(newValue, forKey: "startDate")
        }
    }

    public var endDateDate: Date? {
        get {
            return entityObject.value(forKey: "endDateDate") as? Date
        }
        set {
            entityObject.setValue(newValue, forKey: "endDateDate")
        }
    }

    public var repeatType: String? {
        get {
            return entityObject.value(forKey: "repeatType") as? String
        }
        set {
            entityObject.setValue(newValue, forKey: "repeatType")
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

    public init?(id: Int16, coreDataAssistant: CoreDataAssistant) {
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
