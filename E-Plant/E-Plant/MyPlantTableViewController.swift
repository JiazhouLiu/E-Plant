//
//  MyPlantTableViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 1/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

class MyPlantTableViewController: UITableViewController {

    var plantList: [Plant]?
    var filteredKnowledgeList: [Plant]?
    var managedContext: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    

    
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
    

    func fetchAllPlants() {
        let plantFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Plant")
        
        do {
            plantList = try managedContext?.fetch(plantFetch) as? [Plant]
             let string = String(stringInterpolationSegment: plantList?.count);
              print(string)
        } catch {
            fatalError("Failed to fetch Knowledge Base: \(error)")
        }
    }

    

}
