//
//  Location.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}

