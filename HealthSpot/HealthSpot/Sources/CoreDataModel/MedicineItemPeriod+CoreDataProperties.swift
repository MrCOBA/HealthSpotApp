import Foundation
import CoreData

extension MedicineItemPeriod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicineItemPeriod> {
        return NSFetchRequest<MedicineItemPeriod>(entityName: "MedicineItemPeriod")
    }

    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: Int16
    @NSManaged public var frequency: String?
    @NSManaged public var notificationHint: String?
    @NSManaged public var medicineItem: MedicineItem?

}

extension MedicineItemPeriod : Identifiable {

}
