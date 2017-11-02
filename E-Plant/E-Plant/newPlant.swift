//
//  newPlant.swift
//  E-Plant
//
//  Created by 郁雨润 on 3/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

class newPlant: NSObject {
    
    
      var name: String?
      var condition: String?
      var gardenName: String?
      var knowledgeBaseTitle: String?
      var toGarden: Garden?
      var toKB: KnowledgeBase?
      var toImage: Image?
    
    
    override init(){
        name = "undefiend"
        condition = "undefined"
        gardenName = "undefined"
        toImage?.image =  #imageLiteral(resourceName: "imagePlaceholder")
        knowledgeBaseTitle = "undefined"
        
    }
    
    init(name:String, condition:String, gardenName:String,toImage:Image,knowledgeBaseTitle:String,toGarden: Garden,toKB: KnowledgeBase){
        self.name = name
        self.condition = condition
        self.gardenName = gardenName
        self.toImage = toImage
        self.knowledgeBaseTitle = knowledgeBaseTitle
        self.toGarden = toGarden
        self.toImage = toImage
        self.toKB = toKB
    }

}
