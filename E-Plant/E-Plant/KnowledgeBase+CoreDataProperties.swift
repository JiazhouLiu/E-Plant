//
//  KnowledgeBase+CoreDataProperties.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
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
    @NSManaged public var type: Category?
    @NSManaged public var toPlant: Plant?

}
