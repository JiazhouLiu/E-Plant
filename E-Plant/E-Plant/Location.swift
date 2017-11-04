//
//  Location.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import CoreLocation

class Location {
    // location static variable
    static var sharedInstance = Location()
    private init() {
        self.latitude = -37.876398
        self.longitude = 145.0548502
    }
    
    // location variables
    var latitude: Double!
    var longitude: Double!
}

