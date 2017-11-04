//
//  AddPlantViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 1/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

protocol addPlantDelegate {
    func addPlant(plant: newPlant)
}




class AddPlantViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var plantImage: UIImageView!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var kbTF: UITextField!
    @IBOutlet weak var gardenTF: UITextField!
    @IBOutlet weak var kbButton: UIButton!
    var gardenKLArray:Array<String> = []
    var kbArray:Array<String> = []
    var appDelegate: AppDelegate?
    var gardenKLPickerView: UIPickerView!
    var kbPickerView: UIPickerView!
    var gardenList: [Garden]?
    var KnowledgeBaseList: [KnowledgeBase]?
    var filteredKnowledgeList: [KnowledgeBase]?
    var selectedGaeden: Garden?
    var managedContext: NSManagedObjectContext?
    var plantDelegate: addPlantDelegate?
    var garden: Garden?
    var knowledgeBase: KnowledgeBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchAllKnowledges()
        
        kbPickerView = UIPickerView()
        kbPickerView.delegate = self
        kbPickerView.dataSource = self
        kbButton.addTarget(self, action:#selector(tapped(_:)), for:.touchUpInside)
        gardenKLPickerView = UIPickerView()
        gardenKLPickerView.delegate = self
        gardenKLPickerView.dataSource = self
        gardenTF.inputView = gardenKLPickerView
        
        // Do any additional setup after loading the view.
    }
    
    func tapped(_ button:UIButton){
        kbPickerView.frame = CGRect(x: 60, y: 500, width: 300, height: 200)
        self.view.addSubview(kbPickerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchAllKnowledges() {
        let gardenFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Garden")
        let knowledgeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "KnowledgeBase")
        

        
        do {
            gardenList = try managedContext?.fetch(gardenFetch) as? [Garden]
            KnowledgeBaseList = try managedContext?.fetch(knowledgeFetch) as? [KnowledgeBase]
            filteredKnowledgeList = KnowledgeBaseList?.filter({ (knowledge) -> Bool in return
                (knowledge.category?.contains("Plant"))!})
            
            for i in gardenList!{
                gardenKLArray.append(i.name!)
            }
            
            for k in filteredKnowledgeList!{
                kbArray.append(k.title!)
            }
            
            
        } catch {
            fatalError("Failed to fetch Knowledge Base: \(error)")
        }
    }
    
    

    // pickerView configurations
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == kbPickerView {
            return kbArray[row]
        }else if pickerView == gardenKLPickerView {
            return gardenKLArray[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == kbPickerView {
            kbTF.text = kbArray[row]
            for k in filteredKnowledgeList!{
                if (k.title == kbTF.text){
                    knowledgeBase = k
                     print("check KB111111!!!!!!" + (knowledgeBase?.title)!)
                }
            }
        }else if pickerView == gardenKLPickerView {
            gardenTF.text = gardenKLArray[row]
            for g in gardenList!{
                if (g.name == gardenTF.text){
                    garden = g
                }
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == kbPickerView {
            return kbArray.count
        }else if pickerView == gardenKLPickerView {
            return gardenKLArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == kbPickerView {
            let title = NSAttributedString(string: kbArray[row], attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
            return title
        }else if pickerView == gardenKLPickerView {
            let title = NSAttributedString(string: gardenKLArray[row], attributes: [NSForegroundColorAttributeName : UIColor.darkGray])
            return title
        }
        return nil    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        // Dismiss the view controller depending on the context it was presented
        let isPresentingInAddMode = presentingViewController is UITabBarController
        if isPresentingInAddMode {
            print("test111111")
            dismiss(animated: true, completion: nil)
        } else {
            print("test22222")
            
            navigationController!.popViewController(animated: true)
        }

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
            self.plantImage.image = pickedImage
            self.imageButton.setTitle("", for:.normal)
        }

    }
    
    
    
    
    @IBAction func addPlantButton(_ sender: Any) {
        
        let isPresentingInAddMode = presentingViewController is UITabBarController
        if isPresentingInAddMode {
            if (kbTF.text!.trimmingCharacters(in: .whitespaces).isEmpty){  // the name cannot be empty
                showAlert(title: "name")
            }
            else if(gardenTF.text!.trimmingCharacters(in: .whitespaces).isEmpty){
                showAlert(title: "Garden")
            }
            else if(plantImage == nil){
                plantImage.image = #imageLiteral(resourceName: "imagePlaceholder")
            }
            else {
                let newName = kbTF.text
                let newGardenName = gardenTF.text
                let newCondition = "Good Condition"
                let newKbTitle = "Plant"
                let picture = Image(context: context)
                picture.image = plantImage.image
                
                let newItem = newPlant(name:newName!, condition:newCondition, gardenName:newGardenName!,toImage:picture,knowledgeBaseTitle:newKbTitle,toGarden:garden!,toKB:knowledgeBase!)
                self.plantDelegate!.addPlant(plant: newItem)
                dismiss(animated: true, completion: nil)
             }
      }
    }
    
    
    // alert function
    func showAlert(title: String){
        let alertVC = UIAlertController(title: "Warning", message: "\(title) can not be empty", preferredStyle: UIAlertControllerStyle.alert)
        let acSure = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
            print("click Sure")
        }
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)
    }
    
   

    
    
    

}
