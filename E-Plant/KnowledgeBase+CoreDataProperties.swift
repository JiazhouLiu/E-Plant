//
//  KnowledgeBase+CoreDataProperties.swift
//  E-Plant
//
//  Created by 郁雨润 on 25/10/17.
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

}
