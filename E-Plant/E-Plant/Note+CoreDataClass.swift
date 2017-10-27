//
//  Note+CoreDataClass.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.dateAdded = NSDate()
    }
}
