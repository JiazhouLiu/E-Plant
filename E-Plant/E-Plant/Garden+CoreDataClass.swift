//
//  Garden+CoreDataClass.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 28/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import CoreData

@objc(Garden)
public class Garden: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.customOrder = false
        self.dateAdded = NSDate()
        self.waterUsageUnit = 0.0
        self.waterUsageQty = 0
        self.sensorStatus = "Sensors Off"
        self.lastWaterQty = 0
    }
}
