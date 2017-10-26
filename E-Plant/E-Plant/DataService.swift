//
//  DataService.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//


// User constant
let FIR_CHILD_USERS = "users"


import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class DataService{
    
    // private variable for internal use
    private static let _instance = DataService()
    
    // class initializor
    static var instance: DataService{
        return _instance
    }
    
    
    // References shortcut
    var mainRef: DatabaseReference{
        return Database.database().reference()
    }
    var usersRef: DatabaseReference{
        return mainRef.child(FIR_CHILD_USERS)
    }
    var storageRef: StorageReference{
        return Storage.storage().reference()
    }
    
    // save user into database
    func saveUser(user: User!, username: String, password: String, country: String, gardeningKL: String){
        let profile: Dictionary<String, AnyObject> = ["email": user.email! as AnyObject, "username": username as AnyObject, "country": country as AnyObject, "uid": user.uid as AnyObject, "photoURL": String(describing: user.photoURL!) as AnyObject, "gardeningKL": gardeningKL as AnyObject]
        mainRef.child(FIR_CHILD_USERS).child(user.uid).child("profile").setValue(profile)
    }
    
    // pretrim user info and pass to save user method
    func setUserInfo(user: User!, username: String, password: String, country: String, gardeningKL: String, data: NSData!){
        
        // create path for user image
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        // create image reference
        let imageRef = storageRef.child(imagePath)
        
        // create metadata for the image
        let metadata = StorageMetadata()
        metadata.contentType = "image.jpeg"
        
        // save the user image in the Firebase storage
        imageRef.putData(data as Data, metadata: metadata) { (metaData, error) in
            if error == nil{
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.photoURL = metaData!.downloadURL()
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil{
                        self.saveUser(user: user, username: username, password: password, country: country, gardeningKL: gardeningKL)
                    }else{
                        print(error!.localizedDescription)
                    }
                })
            }else{
                print(error!.localizedDescription)
            }
        }
    }

}

// extension to trim white spaces for string
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
