//
//  Plant+CoreDataProperties.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var orderNo: Int16
    @NSManaged public var name: String?
    @NSManaged public var condition: String?
    @NSManaged public var gardenName: String?
    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var knowledgeBaseTitle: String?
    @NSManaged public var toGarden: Garden?
    @NSManaged public var toKB: KnowledgeBase?
    @NSManaged public var toImage: Image?
    @NSManaged public var toNote: NSSet?

}

// MARK: Generated accessors for toNote
extension Plant {

    @objc(addToNoteObject:)
    @NSManaged public func addToToNote(_ value: Note)

    @objc(removeToNoteObject:)
    @NSManaged public func removeFromToNote(_ value: Note)

    @objc(addToNote:)
    @NSManaged public func addToToNote(_ values: NSSet)

    @objc(removeToNote:)
    @NSManaged public func removeFromToNote(_ values: NSSet)

}
