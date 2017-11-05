//
//  SignUpTVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

// Sign Up Table View Controller for sign up screen
class SignUpTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var userImageView: CustomizableImageView!
    @IBOutlet weak var usernameTF: CustomizableTextField!
    @IBOutlet weak var emailTF: CustomizableTextField!
    @IBOutlet weak var passwordTF: CustomizableTextField!
    @IBOutlet weak var confirmPasswordTF: CustomizableTextField!
    @IBOutlet weak var countryTF: CustomizableTextField!
    @IBOutlet weak var gardenKLTF: CustomizableTextField!
    
    // initiate two picker views
    var countryPickerView: UIPickerView!
    var gardenKLPickerView: UIPickerView!
    var countryArray = [String]()   // array to store countries
    var gardenKLArray = ["Beginner", "Medium", "Expert"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // use country code from iOS system
        for code in NSLocale.isoCountryCodes{
            let locale = Locale(identifier: "en_EN") // Country names in English
            let countryName = locale.localizedString(forRegionCode: code)!
            countryArray.append(countryName)
        }
        
        // setup picker views
        countryPickerView = UIPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryTF.inputView = countryPickerView
        gardenKLPickerView = UIPickerView()
        gardenKLPickerView.delegate = self
        gardenKLPickerView.dataSource = self
        gardenKLTF.inputView = gardenKLPickerView
    }
    
    // pickerView configurations
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView {
            return countryArray[row]
        }else if pickerView == gardenKLPickerView {
            return gardenKLArray[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView {
            countryTF.text = countryArray[row]
        }else if pickerView == gardenKLPickerView {
            gardenKLTF.text = gardenKLArray[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return countryArray.count
        }else if pickerView == gardenKLPickerView {
            return gardenKLArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == countryPickerView {
            let title = NSAttributedString(string: countryArray[row], attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
            return title
        }else if pickerView == gardenKLPickerView {
            let title = NSAttributedString(string: gardenKLArray[row], attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
            return title
        }
        return nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Choose picture when user tapped on the image
    @IBAction func choosePicture(_ sender: Any) {
        let pickerController = UIImagePickerController();
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        // setup a new alert at the bottom to let user choose options
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From ", preferredStyle: .actionSheet)
        
        // pick image from camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                pickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(pickerController, animated: true, completion: nil)
            }
        }
        
        // pick image from photo library
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        }
        
        // pick image from saved photo album
        let savedPhotoAction = UIAlertAction(title: "Saved Photo Album", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                pickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.present(pickerController, animated: true, completion: nil)
            }
        }
        
        // cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // image picker controller handler when finish choose image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            self.userImageView.image = pickedImage
        }
    }

    // sign up button for user to sign up with filled form
    @IBAction func signUpPressed(_ sender: Any) {
        let imgData = UIImageJPEGRepresentation(self.userImageView.image!, 0.8)
        
        if let email = emailTF.text, let pass = passwordTF.text, let passConfirm = confirmPasswordTF.text, let username = usernameTF.text, let country = countryTF.text, let gardeningKL = gardenKLTF.text, (email.characters.count > 0 && pass.characters.count > 0){   // check if email and password are filled
            if passConfirm != pass {
                let alert = UIAlertController(title: "Password Confirmation Error", message: "The password and confirm password do not match", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }else{
                //call the login service
                AuthService.instance.signup(email: email, username: username, password: pass, country: country, gardeningKL: gardeningKL, data: imgData! as NSData, onComplete: { (errMsg, data) in
                    guard errMsg == nil else {  // error handler
                        let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
                        self.present(alert, animated:true, completion: nil)
                        return
                    }
                    // success signup and show it to user, then navigate back to root screen
                    let alertController = UIAlertController(title: "Success", message: "You have successfully signed up!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        self.performSegue(withIdentifier: "signUpToHomeSegue", sender: nil)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }
        else {  // error handling
            let alert = UIAlertController(title: "Email and Password Required", message: "You must enter both an email and a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

}
