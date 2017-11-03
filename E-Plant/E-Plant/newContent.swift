//
//  newContent.swift
//  E-Plant
//
//  Created by 郁雨润 on 3/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

class newContent: NSObject {
    
    var title:String?
    var content:String?
    
    override init(){
        title = "undefiend"
        content = "undefined"
    }
    
    init( title:String, content:String){
        self.title =  title
        self.content = content
        
    }

}
