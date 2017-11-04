//
//  PlantsViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 1/11/17.
//  Modified by Jiazhou Liu on 4/11/17.
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
    var sensorStatus: Bool = false
    
    // check sensor status
    var myTimer: Timer?
    var localTemp1: LocalTemperature1!
    var localTemp2: LocalTemperature2!
    var localTemp3: LocalTemperature3!
    var localMoist1: LocalMoisture1!
    var localMoist2: LocalMoisture2!
    var localMoist3: LocalMoisture3!
    var curTemp: Double = 0.0
    var curPress: Double = 0.0
    var curMoist: Int = 0
    
    // Activity Indicator
    var spinner: UIActivityIndicatorView!
    
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// update code by Joe about checking sensor status
    override func viewDidAppear(_ animated: Bool) {
        // setup spinner
        self.spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height:50))
        self.spinner.color = UIColor.darkGray
        self.spinner.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        self.view.addSubview(spinner)
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        // start timer
        if plant.toGarden != nil{
            if myTimer == nil {
                startTimer()
            }else{
                if !((myTimer?.isValid)!) {
                    startTimer()
                }
            }
        }else { // if no relationship with garden then an archived plant
            conditionLabel.text = "plant out of garden"
            self.tempLabel.text = "unknown"
            self.pressureLabel.text = "unknown"
            self.moistureLabel.text = "unknown"
            self.spinner.stopAnimating()
        }
    }
    
    // invalidate timer after leaving this view to avoid duplicate timer
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if myTimer != nil{
//            myTimer?.invalidate()
//        }
//    }
    
    // start 1s timer to check sensor status
    func startTimer(){
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self,selector: #selector(PlantsViewController.refreshLocalWeather), userInfo: nil, repeats: true)
    }
    
    // refreash sensor data
    func refreshLocalWeather() {
        conditionLabel.text = plant.condition
        if plant.toGarden?.sensorNo == 1{ // if first sensor
            localTemp1 = LocalTemperature1()
            localTemp1.downloadLocalWeatherDetails {
                self.spinner.stopAnimating()
                if self.localTemp1.pressure > 0.0 {
                    self.tempLabel.text = "\(self.localTemp1.temperature) °C"
                    self.pressureLabel.text = "\(self.localTemp1.pressure) kPa"
                    self.curTemp = self.localTemp1.temperature
                    self.curPress = self.localTemp1.pressure
                }else{
                    self.tempLabel.text = "unknown"
                    self.pressureLabel.text = "unknown"
                    self.curTemp = 0.0
                    self.curPress = 0.0
                }
            }
            localMoist1 = LocalMoisture1()
            localMoist1.downloadLocalMoistureDetails {
                self.spinner.stopAnimating()
                if self.localMoist1.moisture > 0 {
                    self.moistureLabel.text = "\(self.localMoist1.moisture)%"
                    self.curMoist = self.localMoist1.moisture
                }else{
                    self.moistureLabel.text = "unknown"
                    self.curMoist = 0
                }
            }
        }else if plant.toGarden?.sensorNo == 2{ // if second sensor
            localTemp2 = LocalTemperature2()
            localTemp2.downloadLocalWeatherDetails {
                self.spinner.stopAnimating()
                if self.localTemp2.pressure > 0.0 {
                    self.tempLabel.text = "\(self.localTemp2.temperature) °C"
                    self.pressureLabel.text = "\(self.localTemp2.pressure) kPa"
                    self.curTemp = self.localTemp2.temperature
                    self.curPress = self.localTemp2.pressure
                }else{
                    self.tempLabel.text = "unknown"
                    self.pressureLabel.text = "unknown"
                    self.curTemp = 0.0
                    self.curPress = 0.0
                }
            }
            localMoist2 = LocalMoisture2()
            localMoist2.downloadLocalMoistureDetails {
                self.spinner.stopAnimating()
                if self.localMoist2.moisture > 0 {
                    self.moistureLabel.text = "\(self.localMoist2.moisture)%"
                    self.curMoist = self.localMoist2.moisture
                }else{
                    self.moistureLabel.text = "unknown"
                    self.curMoist = 0
                }
            }
        }else if plant.toGarden?.sensorNo == 3{ // if third sensor
            localTemp3 = LocalTemperature3()
            localTemp3.downloadLocalWeatherDetails {
                self.spinner.stopAnimating()
                if self.localTemp3.pressure > 0.0 {
                    self.tempLabel.text = "\(self.localTemp3.temperature) °C"
                    self.pressureLabel.text = "\(self.localTemp3.pressure) kPa"
                    self.curTemp = self.localTemp3.temperature
                    self.curPress = self.localTemp3.pressure
                }else{
                    self.tempLabel.text = "unknown"
                    self.pressureLabel.text = "unknown"
                    self.curTemp = 0.0
                    self.curPress = 0.0
                }
            }
            localMoist3 = LocalMoisture3()
            localMoist3.downloadLocalMoistureDetails {
                self.spinner.stopAnimating()
                if self.localMoist3.moisture > 0 {
                    self.moistureLabel.text = "\(self.localMoist3.moisture)%"
                    self.curMoist = self.localMoist3.moisture
                }else{
                    self.moistureLabel.text = "unknown"
                    self.curMoist = 0
                }
            }
        }
        checkCondition()
    }
    
    // calculate condition based on sensor data
    func checkCondition(){
        
        if (curTemp != 0.0 || curPress != 0.0 || curMoist != 0){
            var warningFlag = false
            var dangerFlag = false
            if curTemp != 0.0 {
                if curTemp < 0.0 {
                    dangerFlag = true
                }else if (curTemp < 10.0) {
                    warningFlag = true
                }
            }
            if curMoist != 0 {
                if curMoist < 20 {
                    dangerFlag = true
                }else if curMoist < 40 {
                    warningFlag = true
                }
            }
            if dangerFlag {
                self.plant.condition = "danger condition"
            }else if warningFlag {
                self.plant.condition = "warning condition"
            }else {
                self.plant.condition = "healthy condition"
            }
        }else{
            self.plant.condition = "unknown condition"
        }
        ad.saveContext()
        self.conditionLabel.text = self.plant.condition
        if self.plant.condition == "warning condition"{
            self.conditionLabel.textColor = UIColor.orange
        }else if self.plant.condition == "healthy condition"{
            self.conditionLabel.textColor = UIColor.green
        }else if self.plant.condition == "danger condition"{
            self.conditionLabel.textColor = UIColor.red
        }else {
            self.conditionLabel.textColor = UIColor.black
        }
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
        articleField.isScrollEnabled = false
        articleField.isScrollEnabled = true
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
    
//    func offline(){
//        conditionLabel.text = "undefined"
//        moistureLabel.text = "undefined"
//        tempLabel.text = "undefined"
//        pressureLabel.text = "undefined"
//        
//        let alertVC = UIAlertController(title: "Warning", message: "Sensors are offline", preferredStyle: UIAlertControllerStyle.alert)
//        let acSure = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
//            print("click Sure")
//        }
//        alertVC.addAction(acSure)
//        self.present(alertVC, animated: true, completion: nil)
//
//    }
    
   

}
