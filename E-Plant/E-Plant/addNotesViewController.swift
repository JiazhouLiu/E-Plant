//
//  addNotesViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 3/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData
protocol addNoteDelegate {
    func addNote(note: newContent)
}

protocol editNoteDelegate {
    func editNote()
}

class addNotesViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var contentField: UITextView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    var noteDelegate: addNoteDelegate?
    var editDelegate: editNoteDelegate?
    var note: Note?
    var managedContext: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    var person = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for the edit mode, set the title and article
        if note != nil{
            titleField.text = note?.title
            contentField.text = note?.content
            editButton?.title = "edit"
        }

            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //back button method
    @IBAction func backbutton(_ sender: Any) {
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
    
    // alert function
    func showAlert(title: String){
        let alertVC = UIAlertController(title: "Warning", message: "\(title) can not be empty", preferredStyle: UIAlertControllerStyle.alert)
        let acSure = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
            print("click Sure")
        }
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)
    }

    // if the user click the +, it will be create mode, it will create a new note and pass to note list
    // if the user click the note cell, it will be edit mode, and change the value of note
    @IBAction func saveButton(_ sender: Any) {
        let isPresentingInAddMode = presentingViewController is UITabBarController
        if isPresentingInAddMode {
            if (titleField.text!.trimmingCharacters(in: .whitespaces).isEmpty){  // the name cannot be empty
                showAlert(title: "title")
            }
            else if(contentField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
                showAlert(title: "Article")
            }
            else {
                let newName = titleField.text
                let newArticle = contentField.text
               
                let newItem = newContent(title:newName!, content:newArticle!)
                self.noteDelegate!.addNote(note: newItem)
                dismiss(animated: true, completion: nil)
            }
        }
        else{
            if (titleField.text!.trimmingCharacters(in: .whitespaces).isEmpty){  // the name cannot be empty
                showAlert(title: "title")
            }
            else if(contentField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
                showAlert(title: "Article")
            }
            else {
                let newName = titleField.text
                let newArticle = contentField.text
                let newDate = NSDate()
                let detail = self.note

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
                do {
                    let results = try managedContext?.fetch(fetchRequest);
                    person = results as! [NSManagedObject]
                    let managedObject = detail
                    managedObject!.setValue(newName, forKey: "title")
                    managedObject!.setValue(newArticle, forKey: "content")
                    managedObject!.setValue(newDate, forKey: "dateAdded")
                    managedObject!.setValue(note?.plantName, forKey: "PlantName")
                    managedObject!.setValue(note?.toPlant, forKey: "toPlant")
                    
                    try managedContext?.save()
                }
                catch let error as NSError {
                    print("Could not Fetch \(error), \(error.userInfo)")
                }
                self.editDelegate!.editNote()
                navigationController!.popViewController(animated: true)

            }
            
        }
        
    }
}
