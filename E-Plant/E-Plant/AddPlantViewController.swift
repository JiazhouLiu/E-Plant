//
//  AddPlantViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 1/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

class AddPlantViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    
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
    
    var managedContext: NSManagedObjectContext?

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }else if pickerView == gardenKLPickerView {
            gardenTF.text = gardenKLArray[row]
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

}
