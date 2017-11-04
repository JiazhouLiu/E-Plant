//
//  UpdateProfileTVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

// update profile table view controller for update profile screen
class UpdateProfileTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var userImageView: CustomizableImageView!
    @IBOutlet weak var username: CustomizableTextField!
    @IBOutlet weak var email: CustomizableTextField!
    @IBOutlet weak var newPasswordTF: CustomizableTextField!
    @IBOutlet weak var country: CustomizableTextField!
    @IBOutlet weak var gardeningKLTF: CustomizableTextField!
    @IBOutlet weak var imageChangeBtn: CustomizableButton!
    
    var urlImage: String!
    var countryPickerView: UIPickerView!
    var gardenKLPickerView: UIPickerView!
    var countryArray = [String]()   // array to store countries
    var gardenKLArray = ["Beginner", "Medium", "Expert"]
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tap gesture configuration for dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // get current userID
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        // spinner setup
        self.spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        self.spinner.color = UIColor.lightGray
        self.spinner.center = CGPoint(x: self.view.frame.width / 2, y: 135)
        self.view.addSubview(spinner)
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        
        // get user attriute from database
        ref.child("users").child(userID!).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let usernameD = value?["username"] as? String ?? ""
            self.username.text = usernameD
            let emailD = value?["email"] as? String ?? ""
            self.email.text = emailD
            //let photoURL = value?["photoURL"] as? String ?? ""
            let storageRef: StorageReference! = DataService.instance.storageRef
            // create path for user image
            let imagePath = "profileImage\(userID!)/userPic.jpg"
            
            // create image reference
            let imageRef = storageRef.child(imagePath)
            imageRef.getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    if let data = data {
                        self.userImageView.image = UIImage(data: data)
                        self.spinner.stopAnimating()
                    }
                }
            })
            let countryD = value?["country"] as? String ?? ""
            self.country.text = countryD
            let gardeningKL = value?["gardeningKL"] as? String ?? ""
            self.gardeningKLTF.text = gardeningKL
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // get country code
        for code in NSLocale.isoCountryCodes{
            let locale = Locale(identifier: "en_EN") // Country names in English
            let countryName = locale.localizedString(forRegionCode: code)!
            countryArray.append(countryName)
        }
        
        // setup picker views
        countryPickerView = UIPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        country.inputView = countryPickerView
        gardenKLPickerView = UIPickerView()
        gardenKLPickerView.delegate = self
        gardenKLPickerView.dataSource = self
        gardeningKLTF.inputView = gardenKLPickerView
    }

    // hide keyboard when tap to blank space
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
            country.text = countryArray[row]
        }else if pickerView == gardenKLPickerView {
            gardeningKLTF.text = gardenKLArray[row]
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
    
    // choose picture when user tapped on the image
    @IBAction func choosePicture(_ sender: Any) {
        // setup picker controller for images
        let pickerController = UIImagePickerController();
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        // 3 options for user to choose for iamges
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From ", preferredStyle: .actionSheet)
        
        // choose image from camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                pickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(pickerController, animated: true, completion: nil)
            }
        }
        
        // choose image from photos library
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        }
        
        // choose image from save photo albums
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
    
    
    // manipulate image after chosen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            self.userImageView.image = pickedImage
        }
    }
    
    // update Button pressed
    @IBAction func updateBtnPressed(_ sender: Any) {
        let imgData = UIImageJPEGRepresentation(self.userImageView.image!, 0.8)
        var messageString = ""
        var messageTitle = ""
        if let email = email.text, let country = country.text, let gardeningKL = gardeningKLTF.text, let username = username.text, email.characters.count > 0 {   // all necessary attribute filled
            
            if let password = newPasswordTF.text, password.characters.count > 0{
                // check if contains space
                var spaceFlag = false
                let whitespace = NSCharacterSet.whitespaces
                let range = password.rangeOfCharacter(from: whitespace)
                
                // range will be nil if no whitespace is found
                if let _ = range {
                    spaceFlag = true
                }
                else {
                    spaceFlag = false
                }
                if (password.characters.count >= 6 && !spaceFlag){
                    var messageString = "You have successfully updated your profile"
                    var messageTitle = "Success"
                    DataService.instance.setUserInfo(user: Auth.auth().currentUser, username: username, password: password, country: country, gardeningKL: gardeningKL, data: imgData! as NSData)
                    
                    // change email
                    Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                        if error == nil {   // email changed successfully
                            print("Your email has been changed! Thank you")
                        }else{
                            print(error!.localizedDescription)
                            messageTitle = "Error"
                            messageString = error!.localizedDescription
                        }
                        let alertController = UIAlertController(title: messageTitle, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            if messageTitle != "Error"{ // handle error
                                // Dismiss the view controller depending on the context it was presented
                                let isPresentingInAddMode = self.presentingViewController is UITabBarController
                                if isPresentingInAddMode {
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    self.navigationController!.popViewController(animated: true)
                                }
                            }
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    AuthService.instance.changePassword(password: password)
                }else{
                    // password must be 6 chars or more
                    messageTitle = "Error"
                    messageString = "Password must be at least 6 chars without space"
                    let alertController = UIAlertController(title: messageTitle, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }else{
                DataService.instance.setUserInfo(user: Auth.auth().currentUser, username: username, password: "", country: country, gardeningKL: gardeningKL, data: imgData! as NSData)
                
                // change email
                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                    if error == nil {   // email changed successfully
                        print("Your email has been changed! Thank you")
                    }else{
                        print(error!.localizedDescription)
                        messageTitle = "Error"
                        messageString = error!.localizedDescription
                    }
                    let alertController = UIAlertController(title: messageTitle, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        if messageTitle != "Error"{ // handle error
                            // Dismiss the view controller depending on the context it was presented
                            let isPresentingInAddMode = self.presentingViewController is UITabBarController
                            if isPresentingInAddMode {
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                self.navigationController!.popViewController(animated: true)
                            }
                        }
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        else {  // user email must be entered
            let alert = UIAlertController(title: "User email Required", message: "You must enter an email for the login", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // back button pressed
    @IBAction func backBtnPressed(_ sender: Any) {
        // Dismiss the view controller depending on the context it was presented
        let isPresentingInAddMode = self.presentingViewController is UITabBarController
        if isPresentingInAddMode {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController!.popViewController(animated: true)
        }
    }
    // cancel button pressed
    @IBAction func cancelBtnPressed(_ sender: Any) {
        // Dismiss the view controller depending on the context it was presented
        let isPresentingInAddMode = self.presentingViewController is UITabBarController
        if isPresentingInAddMode {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController!.popViewController(animated: true)
        }
    }
}
