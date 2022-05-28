//
//  MedicineItemPeriod+CoreDataProperties.swift
//  HealthSpot
//
//  Created by Oparin on 28.05.2022.
//
//

import Foundation
import CoreData


extension MedicineItemPeriod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicineItemPeriod> {
        return NSFetchRequest<MedicineItemPeriod>(entityName: "MedicineItemPeriod")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var frequency: String?
    @NSManaged public var id: String?
    @NSManaged public var notificationHint: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var medicineItem: MedicineItem?

}

extension MedicineItemPeriod : Identifiable {

}
