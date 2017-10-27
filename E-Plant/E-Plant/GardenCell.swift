//
//  GardenCell.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

class GardenCell: UITableViewCell {

    @IBOutlet weak var gardenThumb: UIImageView!
    @IBOutlet weak var gardenTitle: UILabel!
    @IBOutlet weak var gardenNumber: UILabel!
    @IBOutlet weak var lastWaterTime: UILabel!
    @IBOutlet weak var sensorStatus: UILabel!
    
    
    // configure cell with input category object and order
    func configureCell(item: Garden, order: Int){
        if item.orderNo != Int16(order) {
            item.orderNo = Int16(order)
        }
        
        if item.lastWaterTime == nil {
            lastWaterTime.text = "Haven't Watered"
        }else {
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "MMM dd, yyyy"
            let dateString = formatter.string(from: item.lastWaterTime! as Date)
            lastWaterTime.text = "Last Watered: \(dateString)"
        }
        
        sensorStatus.text = item.sensorStatus!
        if let status = item.sensorStatus {
            if status == "Sensors On" {
                sensorStatus.textColor = UIColor.green
            }else {
                sensorStatus.textColor = UIColor.brown
            }
        }
        gardenTitle.text = item.name
        if let count = item.toPlant?.count{
            gardenNumber.text = "\(count) Plants"
        }else {
            gardenNumber.text = "error get plants!"
        }
        
        gardenThumb.image = item.toImage?.image as? UIImage
        
    }

}
