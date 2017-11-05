//
//  WaterTableViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 26/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

class WaterTableViewController: UITableViewController,addWaterKnowledgeDelegate{
    
    var KnowledgeBaseList: [KnowledgeBase]?
    var filteredKnowledgeList: [KnowledgeBase]?
    var managedContext: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    var newKnowledge: NewKnowledge?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchAllKnowledges() // get all water knowledge
        
        // if there is no item in the db, create sample data
        if filteredKnowledgeList?.count == 0 {
            print("test11111")
            createDefaultItems()
            fetchAllKnowledges()
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // number of sections in table
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let count = filteredKnowledgeList?.count {
            return count
        }
        
        return 0;    }
    // configure the cell for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "waterKnowledgeCell", for: indexPath) as! WaterTableViewCell
        let knowledge = filteredKnowledgeList![indexPath.row]
        cell.titleLabel.text = knowledge.title
        return cell
        
    }
    // get all water knowledge from db
    func fetchAllKnowledges() {
        let knowledgeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "KnowledgeBase")
        
        do {
            KnowledgeBaseList = try managedContext?.fetch(knowledgeFetch) as? [KnowledgeBase]
            filteredKnowledgeList = KnowledgeBaseList?.filter({ (knowledge) -> Bool in return
                (knowledge.category?.contains("Water"))!})
        } catch {
            fatalError("Failed to fetch Knowledge Base: \(error)")
        }
    }
    
    // pass the data before jump to that view page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "waterKnowledgeDetail") {
            let selectedCategory = filteredKnowledgeList![(tableView.indexPathForSelectedRow?.row)!]
            let destination: WaterViewController = segue.destination as! WaterViewController
            destination.knowledge = selectedCategory
        }
            
        else if(segue.identifier == "addWaterKnowledge"){
            let destination: AddSoilKnowledgeViewController = segue.destination.childViewControllers[0] as! AddSoilKnowledgeViewController
            destination.waterDelegate = self
        }
        
        
        
    }
    
    // create a knowledge
    func createManagedKnowledge(title: String,category: String, article:String) -> KnowledgeBase {
        let knowledge = NSEntityDescription.insertNewObject(forEntityName: "KnowledgeBase", into: managedContext!) as! KnowledgeBase
        knowledge.title = title
        knowledge.article = article
        knowledge.category = category
        return knowledge
    }
    
    
    // create a category
    func createManagedCategory(name: String) -> Category {
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedContext!) as! Category
        category.name = name
        
        return category
    }

    // create the sample data
    func createDefaultItems() {
       
        let water = createManagedCategory(name: "Water")
        
        water.addToMembers(createManagedKnowledge(title: "Water Saving Tips 1", category: "Water", article: "Check all faucets, pipes and toilets for leaks."))
        water.addToMembers(createManagedKnowledge(title: "Water Saving Tips 2", category: "Water", article: "Install water saving showerheads and ultra-low-flush toilets."))
        water.addToMembers(createManagedKnowledge(title: "Water Saving Tips 3", category: "Water", article: "Take shorter showers."))
                appDelegate?.saveContext()
    }

    // add the water knowledge to dbby received object NoewKnowledge
    // refresh the list after add a water knwledge
    func addWaterKnowledge(knowledge:NewKnowledge){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        let knowledge1 = NSEntityDescription.insertNewObject(forEntityName: "KnowledgeBase", into: managedContext!) as! KnowledgeBase
        knowledge1.title = knowledge.title
        knowledge1.category = knowledge.category
        knowledge1.article = knowledge.article
        appDelegate.saveContext()
        
        fetchAllKnowledges()
        self.tableView.reloadData()
    }
    
    // delete function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedContext?.delete(filteredKnowledgeList![indexPath.row])
            filteredKnowledgeList!.remove(at: indexPath.row)
            
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
    

    
    
    // go back to previous view
    @IBAction func backButton(_ sender: Any) {
        // Dismiss the view controller depending on the context it was presented
        let isPresentingInAddMode = presentingViewController is UITabBarController
        print("test11111111")
        if isPresentingInAddMode {
            print("test222222")
            dismiss(animated: true, completion: nil)
        } else {
            print("test33333")
            navigationController!.popViewController(animated: true)
        }
    }
    
    


}
