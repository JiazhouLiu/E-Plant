//
//  SoilKnowledgeTableViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 25/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import CoreData

class SoilKnowledgeTableViewController: UITableViewController,UISearchBarDelegate,addKnowledgeDelegate{
    
    
    var KnowledgeBaseList: [KnowledgeBase]?
    var filteredKnowledgeList: [KnowledgeBase]?
    var managedContext: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    var newKnowledge: NewKnowledge?
    
    var path:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        fetchAllKnowledges()
        
       if KnowledgeBaseList?.count == 0 {
          createDefaultItems()
            fetchAllKnowledges()
       }
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
        if let count = filteredKnowledgeList?.count {
            return count
        }
        
        return 0;
    }
    
    
    // setting the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SoilKnowledgeCell", for: indexPath) as! soilKnowledgeCell
          let knowledge = filteredKnowledgeList![indexPath.row]
          cell.titleLabel.text = knowledge.title
          return cell
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "soilKnowledgeDetail") {
            let selectedCategory = KnowledgeBaseList![(tableView.indexPathForSelectedRow?.row)!]
            let destination: SoilKnowledgeViewController = segue.destination as! SoilKnowledgeViewController
            destination.knowledge = selectedCategory
        }
            
        else if(segue.identifier == "addSoilKnowledge"){
            let destination: AddSoilKnowledgeViewController = segue.destination.childViewControllers[0] as! AddSoilKnowledgeViewController
            destination.delegate = self
        }
        
        
        
    }
    
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
    
    
    
    func createManagedCategory(name: String) -> Category {
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedContext!) as! Category
        category.name = name
       
        return category
    }

    
    
    
    func createManagedKnowledge(title: String,category: String, article:String) -> KnowledgeBase {
        let knowledge = NSEntityDescription.insertNewObject(forEntityName: "KnowledgeBase", into: managedContext!) as! KnowledgeBase
        knowledge.title = title
        knowledge.article = article
        knowledge.category = category
        return knowledge
    }
    
    
    
    func createDefaultItems() {
        let soil = createManagedCategory(name: "Soil")
        let water = createManagedCategory(name: "Water")
        let plant = createManagedCategory(name: "Plant")
        soil.addToMembers(createManagedKnowledge(title: "How to Choose Soil", category: "Soil", article: "123"))
        water.addToMembers(createManagedKnowledge(title: "How to save water", category: "Water", article: "123"))
        plant.addToMembers(createManagedKnowledge(title: "How to grow plant", category: "Plant", article: "123"))
        appDelegate?.saveContext()
    }
    
    
    
    
    
    
    
    
    
    
    func fetchAllKnowledges() {
        let knowledgeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "KnowledgeBase")
        
        do {
            KnowledgeBaseList = try managedContext?.fetch(knowledgeFetch) as? [KnowledgeBase]
            filteredKnowledgeList = KnowledgeBaseList?.filter({ (knowledge) -> Bool in return
                (knowledge.category?.contains("Soil"))!})
        } catch {
            fatalError("Failed to fetch Knowledge Base: \(error)")
        }
    }
    
    func addKnowledge(knowledge:NewKnowledge){
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
    
    @IBAction func backbutton(_ sender: UIBarButtonItem) {
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
