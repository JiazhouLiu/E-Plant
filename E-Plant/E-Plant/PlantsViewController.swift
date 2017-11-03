//
//  PlantsViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 1/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

class PlantsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,addNoteDelegate,editNoteDelegate {

    var plant:Plant!
    var managedContext: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    @IBOutlet weak var plantViewSegment: UISegmentedControl!
    @IBOutlet weak var articleField: UITextView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var moistureLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var addNotes: UIBarButtonItem!
    @IBOutlet weak var notesTableView: UITableView!
    var noteList: [Note]?
    var filteredNoteList: [Note]?
    var sensorStatus: String = "off line"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchAllNotes()
        plantImage.image = plant.toImage?.image as? UIImage
        conditionLabel.text = plant.condition
        self.title = plant.name
        articleField.text = plant.toKB?.article
        
        showPlantStatus()
        if filteredNoteList?.count == 0{
            addSampleNote()
        }
        if sensorStatus == "off line"{
            offline()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPlantStatus() {
        articleField.isHidden = true
        notesTableView.isHidden = true
        addNotes.isEnabled = false
        conditionLabel.isHidden = false
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear;
    }
    
    func showPlantProfile() {
        articleField.isHidden = false
        addNotes.isEnabled = false
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear;
        notesTableView.isHidden = true
        conditionLabel.isHidden = true
    }
    
    func showNotes() {
        articleField.isHidden = true
        conditionLabel.isHidden = true
        addNotes.isEnabled = true
        
        notesTableView.isHidden = false
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue;
    }

    @IBAction func backButton(_ sender: Any) {
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
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        if plantViewSegment.selectedSegmentIndex == 0 {
            showPlantStatus()
        }else if plantViewSegment.selectedSegmentIndex == 1{
            showPlantProfile()
        }
        else if plantViewSegment.selectedSegmentIndex == 2{
            showNotes() 
        }
    }
    
    
    func fetchAllNotes() {
        let noteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        do {
            filteredNoteList = try managedContext?.fetch(noteFetch) as? [Note]
            noteList = filteredNoteList?.filter({ (note) -> Bool in return
                (note.plantName?.contains(plant.name!))!})
            
//            noteList = try managedContext?.fetch(noteFetch) as? [Note]
           
           
        } catch {
            fatalError("Failed to fetch Knowledge Base: \(error)")
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = noteList?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as!
        NotesTableViewCell
        let note = noteList![indexPath.row]
        cell.titleLabel.text = note.title
        cell.timeLabel.text = convertDate(newDate: note.dateAdded!)
        cell.contentLabel.text = note.content
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedContext?.delete(noteList![indexPath.row])
            noteList!.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.notesTableView.reloadSections(NSIndexSet(index:0) as IndexSet, with: .fade)
            do{
                try managedContext?.save()
            }
            catch let error{
                print("Could not save: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if(segue.identifier == "addNotes") {
            let destination: addNotesViewController = segue.destination.childViewControllers[0] as! addNotesViewController
            destination.noteDelegate = self
        }
        
        if(segue.identifier == "editNotes") {
            let destination: addNotesViewController = segue.destination as! addNotesViewController
             let selectedNote = noteList![(notesTableView.indexPathForSelectedRow?.row)!]
            destination.note = selectedNote
            destination.editDelegate = self
        }
    }
    
    func convertDate(newDate: NSDate) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SSS"
        let strNowTime = timeFormatter.string(from: newDate as Date) as String
        return strNowTime
    }
    
    func addSampleNote(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
         let note1 = NSEntityDescription.insertNewObject(forEntityName: "Note", into: managedContext!) as! Note
        note1.dateAdded = NSDate()
        note1.title = "today's work1"
        note1.content = "Water and cutting"
        note1.toPlant = plant
        note1.plantName = "Mint"
        appDelegate.saveContext()
        fetchAllNotes()
        self.notesTableView.reloadData()
        
    }
    
    func addNote(note:newContent){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        let note1 = NSEntityDescription.insertNewObject(forEntityName: "Note", into: managedContext!) as! Note
        note1.title = note.title
        note1.content = note.content
        note1.dateAdded = NSDate()
        note1.plantName = plant.name
        note1.toPlant = plant
        appDelegate.saveContext()
        fetchAllNotes()
        self.notesTableView.reloadData()
    }
    
    func editNote(){
        fetchAllNotes()
        self.notesTableView.reloadData()
    }
    
    func offline(){
        conditionLabel.text = "undefined"
        moistureLabel.text = "undefined"
        tempLabel.text = "undefined"
        pressureLabel.text = "undefined"
        
        let alertVC = UIAlertController(title: "Warning", message: "Sensors are offline", preferredStyle: UIAlertControllerStyle.alert)
        let acSure = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
            print("click Sure")
        }
        alertVC.addAction(acSure)
        self.present(alertVC, animated: true, completion: nil)

    }
    
   

}
