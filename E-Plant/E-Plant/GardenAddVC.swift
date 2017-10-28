//
//  GardenAddVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 28/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class GardenAddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var gardenImage: UIImageView!
    @IBOutlet weak var gardenNameTF: CustomizableTextField!
    @IBOutlet weak var gardenLatTF: CustomizableTextField!
    @IBOutlet weak var gardenLongTF: CustomizableTextField!
    @IBOutlet weak var sensorTF: CustomizableTextField!
    
    // sensor picker view variables
    var sensorPickerView: UIPickerView!
    var sensorArray = ["1", "2", "3"]
    
    // get current location variable
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide keyboard when tapped other place
        self.hideKeyboardWhenTappedAround()
        
        // setup picker views
        sensorPickerView = UIPickerView()
        sensorPickerView.delegate = self
        sensorPickerView.dataSource = self
        sensorTF.inputView = sensorPickerView
        
        // location manager setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check location service status
        locationAuthStatus()
        
    }
    
    // check auth status to make request if needed
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            let lat = currentLocation.coordinate.latitude
            let long = currentLocation.coordinate.longitude
            if lat != nil && long != nil {
                Location.sharedInstance.latitude = lat
                Location.sharedInstance.longitude = long
            }else {
                Location.sharedInstance.latitude = -37.876398
                Location.sharedInstance.longitude = 145.0548502
            }
        }else {
            locationManager.requestWhenInUseAuthorization()
            //locationAuthStatus()
        }
    }
    
    // if changed auth status then show user location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
        }
    }
    
    // pickerView configurations
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

       return sensorArray[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

       sensorTF.text = sensorArray[row]

        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return sensorArray.count

    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        let title = NSAttributedString(string: sensorArray[row], attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
        return title

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    @IBAction func saveBtnPressed(_ sender: Any) {
    
        
        if let name = gardenNameTF.text, let lat = gardenLatTF.text, let long = gardenLongTF.text, let sensor = sensorTF.text{
            
            if(name.characters.count <= 0){
                let alert = UIAlertController(title: "Garden Name Required", message: "Please enter a name for garden", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }else if (sensor.characters.count <= 0){
                let alert = UIAlertController(title: "Garden Sensor Info Required", message: "Please choose one of three sensors for this garden", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }else if (lat.characters.count <= 0){
                let alert = UIAlertController(title: "Garden Location Required", message: "Please enter a valid latitude for this garden", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }else if (long.characters.count <= 0){
                let alert = UIAlertController(title: "Category Location Required", message: "Please enter a valid longitude for this garden", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }else{
                
                let latValue = Double(myCustomFormat:lat)
                let longValue = Double(myCustomFormat:long)
                if latValue == nil{
                    let alert = UIAlertController(title: "Latitude Format Error", message: "Please enter correct format for latitude (example: -37.888)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                }else if longValue == nil {
                    let alert = UIAlertController(title: "Longitude Format Error", message: "Please enter correct format for longitude (example: 145.010101)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                }else{
                    if (sensor == "1" || sensor == "2" || sensor == "3"){
                        var garden: Garden!
                        let picture = Image(context: context)
                        picture.image = gardenImage.image
                        
                        garden = Garden(context: context)
                        
                        garden.toImage = picture
                        garden.name = name
                        garden.sensorNo = Int16(sensor)!
                        garden.latitude = latValue!
                        garden.longitude = longValue!
                        
                        ad.saveContext()
                        navigationController?.popViewController(animated: true)
                    }else{
                        let alert = UIAlertController(title: "Garden Sensor Info Required", message: "Please choose one of three sensors for this garden", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
                    }
                }
            }
        }

    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        // Dismiss the view controller depending on the context it was presented
        let isPresentingInAddMode = presentingViewController is UITabBarController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    @IBAction func currentLocationBtnPressed(_ sender: Any) {
        gardenLatTF.text = "\(currentLocation.coordinate.latitude)"
        gardenLongTF.text = "\(currentLocation.coordinate.longitude)"
    }
    
    @IBAction func chooseImage(_ sender: Any) {
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
            self.gardenImage.image = pickedImage
        }
    }
    

}
