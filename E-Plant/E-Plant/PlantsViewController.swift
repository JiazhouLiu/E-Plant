//
//  PlantsViewController.swift
//  E-Plant
//
//  Created by 郁雨润 on 1/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

class PlantsViewController: UIViewController {

    var plant:Plant!
    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var moistureLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantImage.image = plant.toImage?.image as? UIImage
        conditionLabel.text = plant.condition
        self.title = plant.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

}
