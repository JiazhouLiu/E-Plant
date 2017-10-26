//
//  SignInVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

// Sign In View Controller for Sign In Screen
class SignInVC: UIViewController {

    @IBOutlet weak var emailTF: CustomizableTextField!
    @IBOutlet weak var passwordTF: CustomizableTextField!
    @IBOutlet weak var togglePwdBtn: UIButton!
    
    var showPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // IBAction for user when clicking on the forgot password button
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        // push segue already in use
    }
    
    // toggle button for user to show/hide password
    @IBAction func togglePwdBtnPressed(_ sender: Any) {
        if !showPassword {
            showPassword = true
            togglePwdBtn.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
            passwordTF.isSecureTextEntry = false
        }else {
            showPassword = false
            togglePwdBtn.setImage(#imageLiteral(resourceName: "show"), for: .normal)
            passwordTF.isSecureTextEntry = true
        }
    }
    
    // sign in button for user to sign in to the application using email and password
    @IBAction func signInBtnPressed(_ sender: Any) {
        if let email = emailTF.text, let pass = passwordTF.text, (email.characters.count > 0 && pass.characters.count > 0){
            //call the login service
            AuthService.instance.login(email: email, password: pass, onComplete: { (errMsg, data) in    // use login using auth service
                guard errMsg == nil else {  // handle error
                    let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
                    self.present(alert, animated:true, completion: nil)
                    return
                }
                
                // alert to show message to user about successfully logged in
                let alertController = UIAlertController(title: "Success", message: "You have successfully logged in!", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    self.performSegue(withIdentifier: "signInToHomeSegue", sender: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
        else {  // error log in
            let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both a username and a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // sign up button for user to sign up
    @IBAction func signUpBtnPressed(_ sender: Any) {
        // push segue already in use
    }
    
    // toast function for notification
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height/2, width: 300, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 3
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}

// Hide key board when tapped around applied to all view controller
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// dismiss editing/hide keyboard applied to all table view
extension UITableView {
    
    func dismissEditing(){
        if self.isEditing {
            self.isEditing = false
        }
    }
    
    func startEditing(){
        if !self.isEditing{
            self.isEditing = true
        }
    }
}

