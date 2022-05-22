import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var medicineItems: NSSet?

}

// MARK: Generated accessors for medicineItems

extension User {

    @objc(insertObject:inMedicineItemsAtIndex:)
    @NSManaged public func insertIntoMedicineItems(_ value: MedicineItem, at idx: Int)

    @objc(removeObjectFromMedicineItemsAtIndex:)
    @NSManaged public func removeFromMedicineItems(at idx: Int)

    @objc(insertMedicineItems:atIndexes:)
    @NSManaged public func insertIntoMedicineItems(_ values: [MedicineItem], at indexes: NSIndexSet)

    @objc(removeMedicineItemsAtIndexes:)
    @NSManaged public func removeFromMedicineItems(at indexes: NSIndexSet)

    @objc(replaceObjectInMedicineItemsAtIndex:withObject:)
    @NSManaged public func replaceMedicineItems(at idx: Int, with value: MedicineItem)

    @objc(replaceMedicineItemsAtIndexes:withMedicineItems:)
    @NSManaged public func replaceMedicineItems(at indexes: NSIndexSet, with values: [MedicineItem])

    @objc(addMedicineItemsObject:)
    @NSManaged public func addToMedicineItems(_ value: MedicineItem)

    @objc(removeMedicineItemsObject:)
    @NSManaged public func removeFromMedicineItems(_ value: MedicineItem)

    @objc(addMedicineItems:)
    @NSManaged public func addToMedicineItems(_ values: NSOrderedSet)

    @objc(removeMedicineItems:)
    @NSManaged public func removeFromMedicineItems(_ values: NSOrderedSet)

}

extension User : Identifiable {

}
