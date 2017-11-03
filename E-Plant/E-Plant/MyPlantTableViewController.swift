//
//  MyPlantTableViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 1/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

class MyPlantTableViewController: UITableViewController,addPlantDelegate{

    var plantList: [Plant]?
    var filteredKnowledgeList: [Plant]?
    var managedContext: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    var filterGarden: Garden?
    

    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchAllPlants()
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let count = plantList?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlantCell", for: indexPath) as! MyPlantTableViewCell
        let plant = plantList![indexPath.row]
        cell.nameLabel.text = plant.name
        cell.conditionLabel.text = plant.condition
        
        if (plant.toImage == nil){
           cell.plantImage.image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        else{
            cell.plantImage.image = plant.toImage?.image as? UIImage
        }
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "plantViewIdentifier") {
            let selectedCategory = plantList![(tableView.indexPathForSelectedRow?.row)!]
            let destination: PlantsViewController = segue.destination as! PlantsViewController
            destination.plant = selectedCategory
        }
        else if(segue.identifier == "addPlantIdentifier") {
            let destination: AddPlantViewController = segue.destination.childViewControllers[0] as! AddPlantViewController
            destination.plantDelegate = self
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedContext?.delete(plantList![indexPath.row])
            plantList!.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadSections(NSIndexSet(index:0) as IndexSet, with: .fade)
            do{
                try managedContext?.save()
            }
            catch let error{
                print("Could not save: \(error)")
            }
        }
        
        
    }
    
    // enable move function
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    // filter the plant if user enter from the garden list
    // otherwise will show all plants
    func fetchAllPlants() {
        let plantFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Plant")
        
        do {
            if filterGarden?.name != nil{
                filteredKnowledgeList = try managedContext?.fetch(plantFetch) as? [Plant]
                plantList =  filteredKnowledgeList?.filter({ (plant) -> Bool in return
                    (plant.toGarden?.isEqual(filterGarden))!})
            }
            else{
              plantList = try managedContext?.fetch(plantFetch) as? [Plant]
            }
        } catch {
            fatalError("Failed to fetch Knowledge Base: \(error)")
        }
    }
    
    func addPlant(plant:newPlant){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        let plant1 = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: managedContext!) as! Plant
        plant1.name = plant.name
        plant1.condition = plant.condition
        plant1.dateAdded = getCurrentDate()!
        plant1.toImage = plant.toImage
        plant1.toGarden = plant.toGarden
        plant1.toKB = plant.toKB
        let newNo = (plantList?.count)! + 1
        plant1.orderNo = Int16(newNo)
        plant1.gardenName = plant.gardenName
        plant1.knowledgeBaseTitle = plant.knowledgeBaseTitle
        appDelegate.saveContext()
        fetchAllPlants()
        self.tableView.reloadData()
    }

    // get current date
    func getCurrentDate() -> NSDate?{
        let currentDate = Date()
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: currentDate as Date)
        
        return date1 as NSDate
    }
    
    
    @IBAction func editBtn(_ sender: Any) {
        self.isEditing = !self.isEditing
        if tableView.isEditing {
            editBtn.title = "Save"
        } else {
            editBtn.title = "Edit List"
        }
    }

}
