//
//  GardenSettingsTVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 28/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

class GardenSettingsTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var createdDateTF: UILabel!
    @IBOutlet weak var changeNameTF: UITextField!
    @IBOutlet weak var changeSensorTF: UITextField!
    @IBOutlet weak var changeLatTF: UITextField!
    @IBOutlet weak var changeLongTF: UITextField!
    @IBOutlet weak var waterUsageTF: UITextField!
    
    var selectedGarden: Garden?
    var selectedImage: UIImage?
    
    // sensor picker view variables
    var sensorPickerView: UIPickerView!
    var sensorArray = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGarden()
        // hide keyboard when tapped other place
        self.hideKeyboardWhenTappedAround()
        
        // setup picker views
        sensorPickerView = UIPickerView()
        sensorPickerView.delegate = self
        sensorPickerView.dataSource = self
        changeSensorTF.inputView = sensorPickerView

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func loadGarden() {
        nameTF.text = selectedGarden?.name
        changeNameTF.text = selectedGarden?.name
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "MMM dd, yyyy"
        if let date = selectedGarden?.dateAdded {
            let dateString = formatter.string(from: date as Date)
            createdDateTF.text = "Created On: \(dateString)"
        }
        if let sensor = selectedGarden?.sensorNo {
            changeSensorTF.text = "\(sensor)"
        }
        
        if let oriLat = selectedGarden?.latitude, let oriLong = selectedGarden?.longitude{
            changeLatTF.text = String(oriLat)
            changeLongTF.text = String(oriLong)
        }
        if let usageUnit = selectedGarden?.waterUsageUnit {
            waterUsageTF.text = "\(usageUnit)"
        }
    }
    
    // pickerView configurations
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return sensorArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        changeSensorTF.text = sensorArray[row]
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
            self.selectedImage = pickedImage
            
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "gardenViewFromSettings", sender: selectedGarden)
    }
    
    // prepare for single garden controller segue and take object selected object to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gardenViewFromSettings" {
            if let destination = segue.destination as? GardenViewTVC {
                if let garden = sender as? Garden {
                    destination.selectedGarden = garden
                }
            }
        }
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        if let name = changeNameTF.text, let lat = changeLatTF.text, let long = changeLongTF.text, let sensor = changeSensorTF.text, let usage = waterUsageTF.text{
            
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
                        var unit = usage
                        if unit.characters.count <= 0 {
                            unit = "0.0"
                        }else {
                            let usageValue = Double(myCustomFormat:unit)
                            if usageValue == nil {
                                let alert = UIAlertController(title: "Water Usage Format Error", message: "Please enter correct format for Water Usage (example: 20.5)", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                present(alert, animated: true, completion: nil)
                            }else{
                                var garden: Garden!
                                
                                garden = selectedGarden
                                
                                if let image = selectedImage {
                                    let picture = Image(context: context)
                                    picture.image = image
                                    garden.toImage = picture
                                }
                                
                                garden.name = name
                                garden.sensorNo = Int16(sensor)!
                                garden.latitude = latValue!
                                garden.longitude = longValue!
                                
                                ad.saveContext()
                                navigationController?.popViewController(animated: true)
                            }
                        }
                        
                        
                    }else{
                        let alert = UIAlertController(title: "Garden Sensor Info Required", message: "Please choose one of three sensors for this garden", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    
    @IBAction func removeBtnPressed(_ sender: Any) {
        // get all plants under this garden and delete them
//        var plants = [Plant]()
//        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "toGarden == %@", selectedGarden)
//        
//        do {
//            plants = try context.fetch(fetchRequest)
//        } catch {
//            let error = error as NSError
//            print("\(error)")
//        }
//        //print(plants.count)
//        for item in plants{
//            context.delete(item)
//        }
        context.delete(selectedGarden!)
        ad.saveContext()
        performSegue(withIdentifier: "gardenListFromSettings", sender: nil)
    }
}
