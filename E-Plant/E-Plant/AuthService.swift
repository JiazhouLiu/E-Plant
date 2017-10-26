//
//  AuthService.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit


typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    // private variable to initialize authservice class
    private static let _instance = AuthService()
    
    // initialize this class
    static var instance: AuthService {
        return _instance
    }
    
    // login method, use firebase auth signIn method to login to the system
    func login(email: String, password: String, onComplete: Completion?){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            }else {
                // logged in
                onComplete?(nil, user)
            }
        })
    }
    
    // signup method, create user first and use login method to login after sign up
    func signup(email: String, username: String, password: String, country: String, gardeningKL: String, data: NSData!, onComplete: Completion?){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            }else { // no error
                if user?.uid != nil {
                    DataService.instance.setUserInfo(user: user, username: username, password: password, country: country, gardeningKL: gardeningKL, data: data)
                    self.login(email: email, password: password, onComplete: onComplete)
                }
            }
        })
    }
    
    // logout method, use Firebase auth signout method
    func logout(){
        do {
            try Auth.auth().signOut()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    
    // change Email method, update user auth info: email
    func changeEmail(email: String){
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            if error == nil {
                print("Your email has been changed! Thank you")
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    
    // change password method, update user auth info: password
    func changePassword(password: String){
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if error == nil {
                print("Your password has been changed! Thank you")
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    
    // reset Password method, use this method when user clicks on the forgot password button
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                print("An email about how to reset password has been sent to you! Thank you")
            }else{
                print(error!.localizedDescription)
            }
            
        })
    }
    
    
    // integrated place to handle errors using firebase auth service
    func handleFirebaseError(error: NSError, onComplete: Completion?){
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error._code){
            switch (errorCode){
            case .invalidEmail:    // invalid email
                onComplete?("Invalid email address", nil)
                break
            case .wrongPassword:   // invalid password
                onComplete?("Invalid password", nil)
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential: // email exist and duplicated register error
                onComplete?("Could not create account. Email already in use", nil)
                break
            case .userNotFound:    // user email not in the system
                onComplete?("Email cannot be found, please sign up first", nil)
                break
            default:    // default error
                onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
    }
}

