//
//  ForgotPasswordVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

// Forgot Password View Controller for forgot password screen
class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTF: CustomizableTextField!
    var exist: Bool = false // check exist flag
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // reset Password button pressed
    @IBAction func resetPasswordBtnPressed(_ sender: Any) {
        // use Firebase data service to get email and check if user exist
        DataService.instance.usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // get users reference and all data inside it
            if let users = snapshot.value as? Dictionary<String, AnyObject>{
                for (_, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject>{
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject>{
                            if let email = profile["email"] as? String{
                                if email.lowercased() == self.emailTF.text!.lowercased(){
                                    self.exist = true
                                }
                            }
                        }
                    }
                }
                if self.exist{  // if exist, then reset password
                    AuthService.instance.resetPassword(email: self.emailTF.text!)   // reset password
                    
                    let alertController = UIAlertController(title: "Success", message: "You have successfully requested for password reset. Please check your email to see further instructions.", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        self.performSegue(withIdentifier: "forgotToLogin", sender: nil)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{  // not exist, show error
                    let alert = UIAlertController(title: "No such a user", message: "The user with the email you enterred does not exist", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    

}
