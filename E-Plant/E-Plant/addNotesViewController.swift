//
//  addNotesViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 3/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

protocol addNoteDelegate {
    func addNote(note: newContent)
}

class addNotesViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var contentField: UITextView!
    
    var noteDelegate: addNoteDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        
    }
}
