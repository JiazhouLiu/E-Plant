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
    
    @IBOutlet weak var plantViewSegment: UISegmentedControl!
    @IBOutlet weak var articleField: UITextView!
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
        articleField.text = plant.toKB?.article
        showPlantStatus()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPlantStatus() {
        articleField.isHidden = true
    }
    
    func showPlantProfile() {
        articleField.isHidden = false
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
    }

}
