//
//  FencedAnnotation.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 21/8/17.
//  Copyright © 2017 Jiazhou Liu. All rights reserved.
//

import UIKit
import MapKit

// custom MKAnnotation class model
class FencedAnnotation: NSObject, MKAnnotation {
    
    // attributes as variables
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image:     UIImage?
    var notiRadius: Double?
    var notiOn: Bool?
    
    
    // initializers
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double, img: UIImage, notiR: Double, notiOn:Bool){
        self.title = newTitle
        self.subtitle = newSubtitle
        self.coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = lat
        self.coordinate.longitude = long
        
        self.notiRadius = notiR
        self.notiOn = notiOn
        self.image = img
        
        super.init()
    }
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double){
        self.title = newTitle
        self.subtitle = newSubtitle
        self.coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = lat
        self.coordinate.longitude = long
        
        
        super.init()
    }
}

