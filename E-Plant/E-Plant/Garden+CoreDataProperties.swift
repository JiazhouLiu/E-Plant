//
//  Garden+CoreDataProperties.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 28/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import CoreData


extension Garden {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Garden> {
        return NSFetchRequest<Garden>(entityName: "Garden")
    }

    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var lastWaterTime: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var orderNo: Int16
    @NSManaged public var sensorNo: Int16
    @NSManaged public var waterUsageQty: Int16
    @NSManaged public var waterUsageUnit: Double
    @NSManaged public var sensorStatus: String?
    @NSManaged public var customOrder: Bool
    @NSManaged public var lastWaterQty: Int16
    @NSManaged public var toImage: Image?
    @NSManaged public var toPlant: NSSet?

}

// MARK: Generated accessors for toPlant
extension Garden {

    @objc(addToPlantObject:)
    @NSManaged public func addToToPlant(_ value: Plant)

    @objc(removeToPlantObject:)
    @NSManaged public func removeFromToPlant(_ value: Plant)

    @objc(addToPlant:)
    @NSManaged public func addToToPlant(_ values: NSSet)

    @objc(removeToPlant:)
    @NSManaged public func removeFromToPlant(_ values: NSSet)

}
