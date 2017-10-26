//
//  SettingsTVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// Settings Table View Controller for Settings Screen
class SettingsTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // back button pressed
    @IBAction func backBtnPressed(_ sender: Any) {
        // Dismiss the view controller depending on the context it was presented
        let isPresentingInAddMode = presentingViewController is UITabBarController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    // page navigation based on different row clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if (indexPath.section == 0 && indexPath.row == 0){
            self.performSegue(withIdentifier: "settingsToUpdateProfileSegue", sender: nil) // navigate to Update Profile Screen
        } else if (indexPath.section == 1 && indexPath.row == 0){
            self.performSegue(withIdentifier: "settingsToAboutSegue", sender: nil) // navigate to About Us Screen
        }
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        // run logout function from Firebase auth service
        if Auth.auth().currentUser != nil{
            AuthService.instance.logout()
        }
        
        // show user success message and navigate back to root screen
        let alertController = UIAlertController(title: "Success", message: "You have successfully logged out", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            if let storyboard = self.storyboard {
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }

}
