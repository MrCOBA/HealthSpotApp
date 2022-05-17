import CoreData

public final class MedicineItemPeriodEntityWrapper {

    // MARK: - Public Properties

    public var id: Int16 {
        return entityObject.value(forKey: "id") as? Int16 ?? -1
    }

    public var startDate: Date {
        return entityObject.value(forKey: "startDate") as? Date ?? Date()
    }

    public var endDateDate: Date? {
        return entityObject.value(forKey: "endDate") as? Date
    }

    public var repeatType: String? {
        return entityObject.value(forKey: "repeatType") as? String
    }

    public var notificationHint: String {
        return entityObject.value(forKey: "notificationHint") as? String ?? ""
    }

    public var medicineItem: NSManagedObject? {
        return entityObject.value(forKey: "medicineItem") as? NSManagedObject
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
