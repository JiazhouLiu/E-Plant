//
//  GardenListTVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

class GardenListTVC: UITableViewController, NSFetchedResultsControllerDelegate {

    
    // FRC controller variable
    var controller: NSFetchedResultsController<Garden>!
    // customOrderFlag
    var customOrder:Bool = false
    // edit Btn IBOutlet
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // first Fetch to initialize controller and get all gardens
        attemptFetch()
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[0]
            // if nothing in the controller, add sample data
            if sectionInfo.numberOfObjects == 0{
                generateTestData()
                attemptFetch()
            }else{
                // if controller not empty, get customOrder flag configured
                let gardens = controller.fetchedObjects
                for item in gardens!{
                    if item.customOrder{
                        self.customOrder = true
                    }
                }
                attemptFetch()
            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let sections = controller.sections {
                
                let sectionInfo = sections[section]
                return sectionInfo.numberOfObjects
            }
            return 0
    }

    // call configureCell function to configure cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GardenCell", for: indexPath) as! GardenCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    // take garden object into cell model to configure cell UI elements
    func configureCell(cell: GardenCell, indexPath: NSIndexPath){
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item, order: indexPath.row)
    }
    
    // if select row then perform segue to single garden controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let garden = objs[indexPath.row]
            performSegue(withIdentifier: "gardenViewFromList", sender: garden)
        }
    }
    
    // prepare for single garden controller segue and take object selected object to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gardenViewFromList" {
            if let destination = segue.destination as? GardenViewTVC {
                if let garden = sender as? Garden {
                    destination.selectedGarden = garden
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // enable row editing function
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let deletedGarden = controller.object(at: indexPath as IndexPath)
            // get all plants under this garden and delete them
            var plants = [Plant]()
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "toGarden == %@", deletedGarden)
            
            do {
                plants = try context.fetch(fetchRequest)
            } catch {
                let error = error as NSError
                print("\(error)")
            }
            //print(plants.count)
            for item in plants{
                context.delete(item)
            }
            context.delete(deletedGarden)
            
            ad.saveContext()
            
        }else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // enable move function
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        attemptFetch()
        
        var gardens = controller.fetchedObjects!
        //controller.delegate = nil
        
        let object = gardens[sourceIndexPath.row]
        gardens.remove(at: sourceIndexPath.row)
        gardens.insert(object, at: destinationIndexPath.row)
        
        var i = 0
        for item in gardens{
            self.customOrder = true
            item.customOrder = true
            item.orderNo = Int16(i)
            i += 1
        }
        attemptFetch()
        tableView.reloadData()
    }
    
    // toggle editing mode and edit button text
    @IBAction func editBtnPressed(_ sender: Any) {
        self.isEditing = !self.isEditing
        
        if tableView.isEditing {
            editBtn.title = "Save"
        } else {
            editBtn.title = "Edit List"
        }
    }
    
    // FRC section
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Garden> = Garden.fetchRequest()
        
        if (self.customOrder == false){
            let dateSort = NSSortDescriptor(key: "dateAdded", ascending: false)
            fetchRequest.sortDescriptors = [dateSort]
        }else{
            let customSort = NSSortDescriptor(key: "orderNo", ascending: true)
            fetchRequest.sortDescriptors = [customSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        }catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! GardenCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
        
    }
    
    // generate sample data
    func generateTestData(){
        
        let garden1 = Garden(context: context)
        garden1.name = "Flowers Garden"
        garden1.latitude = -37.882731
        garden1.longitude = 145.048345
        let picture1 = Image(context: context)
        picture1.image = #imageLiteral(resourceName: "flowerGarden")
        garden1.toImage = picture1
        
        let garden2 = Garden(context: context)
        garden2.name = "Vege Garden"
        garden2.latitude = -37.910656
        garden2.longitude = 145.133633
        let picture2 = Image(context: context)
        picture2.image = #imageLiteral(resourceName: "vegeGarden")
        garden2.toImage = picture2
        
        
        ad.saveContext()
    }

}
