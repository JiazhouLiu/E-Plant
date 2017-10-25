//
//  newKnowledge.swift
//  E-Plant
//
//  Created by 郁雨润 on 25/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

class NewKnowledge: NSObject {
    var title:String?
    var category:String?
    var article:String?
    
    override init(){
        title = "Undefined"
        category = "Undefined"
        article = "Undefined"
    }
    
    init(title:String, category:String, article:String){
        self.title = title
        self.article = article
        self.category = category
    }
    

}
