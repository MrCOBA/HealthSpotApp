//
//  User+CoreDataProperties.swift
//  HealthSpot
//
//  Created by Oparin on 28.05.2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var heartRateItems: NSSet?
    @NSManaged public var medicineItems: NSSet?

}

// MARK: Generated accessors for heartRateItems
extension User {

    @objc(addHeartRateItemsObject:)
    @NSManaged public func addToHeartRateItems(_ value: HeartRateItem)

    @objc(removeHeartRateItemsObject:)
    @NSManaged public func removeFromHeartRateItems(_ value: HeartRateItem)

    @objc(addHeartRateItems:)
    @NSManaged public func addToHeartRateItems(_ values: NSSet)

    @objc(removeHeartRateItems:)
    @NSManaged public func removeFromHeartRateItems(_ values: NSSet)

}

// MARK: Generated accessors for medicineItems
extension User {

    @objc(addMedicineItemsObject:)
    @NSManaged public func addToMedicineItems(_ value: MedicineItem)

    @objc(removeMedicineItemsObject:)
    @NSManaged public func removeFromMedicineItems(_ value: MedicineItem)

    @objc(addMedicineItems:)
    @NSManaged public func addToMedicineItems(_ values: NSSet)

    @objc(removeMedicineItems:)
    @NSManaged public func removeFromMedicineItems(_ values: NSSet)

}

extension User : Identifiable {

}
