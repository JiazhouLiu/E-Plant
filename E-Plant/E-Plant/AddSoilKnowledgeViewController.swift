//
//  AddSoilKnowledgeViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 25/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

protocol addKnowledgeDelegate {
    func addKnowledge(knowledge: NewKnowledge)
    
    }

protocol addPlantKnowledgeDelegate {
    func addPlantKnowledge(knowledge: NewKnowledge)
    
}

class AddSoilKnowledgeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var articleField: UITextView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    var knowlege: KnowledgeBase!
    var managedContext: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    var delegate: addKnowledgeDelegate?
    var delegate2: addPlantKnowledgeDelegate?
    var plantDelegate: addPlantKnowledgeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when return key is pressed
        textField.resignFirstResponder()
        return true
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
   
    
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UITabBarController
        print("test11111111")
        if !isPresentingInAddMode {
             print("test2222222")
            if (titleField.text!.trimmingCharacters(in: .whitespaces).isEmpty){  // the name cannot be empty
                showAlert(title: "title")
            }
            else if(articleField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
                
                showAlert(title: "Article")
            }
            else {
                let newTitle = titleField.text
                let newArticle = articleField.text
                var newCategory: String?
                switch (typeSegment.selectedSegmentIndex) {
                    
                case 0:
                     newCategory = "Soil"
                     break
                case 1:
                    newCategory = "Plant"
                    break
                case 2:
                    newCategory = "Water"
                    break
                default:
                    newCategory = "Soil"
                    break
                }
                let newItem = NewKnowledge(title: newTitle!, category: newCategory!, article: newArticle!)
                if(newCategory == "Soil"){
                self.delegate!.addKnowledge(knowledge: newItem)
                }
                else if(newCategory == "Plant"){
                    self.plantDelegate!.addPlantKnowledge(knowledge: newItem)
                }
                
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
   
    
    
   
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        // Dismiss the view controller depending on the context it was presented
        let isPresentingInAddMode = presentingViewController is UITabBarController
        print("test11111111")
        if !isPresentingInAddMode {
            print("test222222")
            dismiss(animated: true, completion: nil)
        } else {
            print("test33333")
            navigationController!.popViewController(animated: true)
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
