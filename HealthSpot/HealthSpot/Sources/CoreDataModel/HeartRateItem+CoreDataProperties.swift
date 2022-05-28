//
//  HeartRateItem+CoreDataProperties.swift
//  HealthSpot
//
//  Created by Oparin on 28.05.2022.
//
//

import Foundation
import CoreData


extension HeartRateItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeartRateItem> {
        return NSFetchRequest<HeartRateItem>(entityName: "HeartRateItem")
    }

    @NSManaged public var date: Date?
    @NSManaged public var heartRate: Double
    @NSManaged public var user: User?

}

extension HeartRateItem : Identifiable {

}
