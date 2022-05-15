import Foundation
import CoreData

extension MedicineItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicineItem> {
        return NSFetchRequest<MedicineItem>(entityName: "MedicineItem")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var marketUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var producer: String?
    @NSManaged public var activeComponent: String?
    @NSManaged public var id: Int16
    @NSManaged public var user: User?
    @NSManaged public var periods: NSSet?

}

// MARK: Generated accessors for periods

extension MedicineItem {

    @objc(addPeriodsObject:)
    @NSManaged public func addToPeriods(_ value: MedicineItemPeriod)

    @objc(removePeriodsObject:)
    @NSManaged public func removeFromPeriods(_ value: MedicineItemPeriod)

    @objc(addPeriods:)
    @NSManaged public func addToPeriods(_ values: NSSet)

    @objc(removePeriods:)
    @NSManaged public func removeFromPeriods(_ values: NSSet)

}

extension MedicineItem : Identifiable {

}
