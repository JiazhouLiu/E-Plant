//
//  User.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

// user class and get attribute from database snapshot
class ApplicationUser {
    
    var username: String!
    var email: String!
    var photoURL: String!
    var country: String!
    var gardeningKL: String!
    var uid: String?
    var ref: DatabaseReference?
    var key: String?
    
    init(snapshot: DataSnapshot){
        
        key = snapshot.key
        username = snapshot.value(forKey: "username") as! String
        email = snapshot.value(forKey: "email") as! String
        photoURL = snapshot.value(forKey: "photoURL") as! String
        country = snapshot.value(forKey: "country") as! String
        gardeningKL = snapshot.value(forKey: "gardeningKL") as! String
        ref = snapshot.ref
    }
    init(username: String, email: String, photoURL: String, country: String, gardeningKL: String){
        self.username = username
        self.email = email
        self.photoURL = photoURL
        self.country = country
        self.gardeningKL = gardeningKL
    }
}
