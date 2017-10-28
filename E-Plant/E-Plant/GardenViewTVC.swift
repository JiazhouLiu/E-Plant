//
//  GardenViewTVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

class GardenViewTVC: UITableViewController {

    var selectedGarden: Garden?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = (selectedGarden?.name)!
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "gardenSettingsFromView", sender: selectedGarden)
    }

    // prepare for single garden controller segue and take object selected object to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gardenSettingsFromView" {
            if let destination = segue.destination as? GardenSettingsTVC {
                if let garden = sender as? Garden {
                    destination.selectedGarden = garden
                }
            }
        }
    }
}
