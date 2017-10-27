//
//  Note+CoreDataProperties.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var content: String?
    @NSManaged public var plantName: String?
    @NSManaged public var toPlant: Plant?

}
