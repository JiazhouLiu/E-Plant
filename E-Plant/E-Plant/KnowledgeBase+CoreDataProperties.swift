//
//  KnowledgeBase+CoreDataProperties.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 4/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import CoreData


extension KnowledgeBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KnowledgeBase> {
        return NSFetchRequest<KnowledgeBase>(entityName: "KnowledgeBase")
    }

    @NSManaged public var article: String?
    @NSManaged public var category: String?
    @NSManaged public var title: String?
    @NSManaged public var toPlant: NSSet?
    @NSManaged public var type: Category?

}

// MARK: Generated accessors for toPlant
extension KnowledgeBase {

    @objc(addToPlantObject:)
    @NSManaged public func addToToPlant(_ value: Plant)

    @objc(removeToPlantObject:)
    @NSManaged public func removeFromToPlant(_ value: Plant)

    @objc(addToPlant:)
    @NSManaged public func addToToPlant(_ values: NSSet)

    @objc(removeToPlant:)
    @NSManaged public func removeFromToPlant(_ values: NSSet)

}
