//
//  GardenCell.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

class GardenCell: UITableViewCell {

    // garden cell IBOutlet variables
    @IBOutlet weak var gardenThumb: UIImageView!
    @IBOutlet weak var gardenTitle: UILabel!
    @IBOutlet weak var gardenNumber: UILabel!
    @IBOutlet weak var lastWaterTime: UILabel!
    @IBOutlet weak var sensorStatus: UILabel!
    
    
    // configure cell with input category object and order
    func configureCell(item: Garden, order: Int, sensor1: Bool, sensor2: Bool, sensor3: Bool){
        // setup garden list item's number
        if item.orderNo != Int16(order) {
            item.orderNo = Int16(order)
        }
        
        // set water time message
        if item.lastWaterTime == nil {
            lastWaterTime.text = "Haven't Watered"
        }else {
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "MMM dd, yyyy"
            let dateString = formatter.string(from: item.lastWaterTime! as Date)
            lastWaterTime.text = "Last Watered: \(dateString)"
        }
        var status = ""
        
        // set status message based on sensor
        if item.sensorNo == 1 {
            if sensor1 {
                status = "Sensors On"
            }else {
                status = "Sensors Off"
            }
        }else if item.sensorNo == 2 {
            if sensor2 {
                status = "Sensors On"
            }else {
                status = "Sensors Off"
            }
        }else if item.sensorNo == 3 {
            if sensor3 {
                status = "Sensors On"
            }else {
                status = "Sensors Off"
            }
        }
        
        sensorStatus.text = status
        if status == "Sensors On" {
            sensorStatus.textColor = UIColor.green
        }else {
            sensorStatus.textColor = UIColor.brown
        }
        
        // set garden title and garden's plant number
        gardenTitle.text = item.name
        if let count = item.toPlant?.count{
            if count <= 1 {
                gardenNumber.text = "\(count) Plant"
            }else{
                gardenNumber.text = "\(count) Plants"
            }
        }else {
            gardenNumber.text = "error get plants!"
        }
        
        // set garden image
        gardenThumb.image = item.toImage?.image as? UIImage
        
    }

}
