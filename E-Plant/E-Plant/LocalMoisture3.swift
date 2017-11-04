//
//  LocalMoisture3.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import Alamofire

class LocalMoisture3: NSObject {
    // local moisture data variables from local sensor 3
    var _moisture: Int!
    var _received: Bool!
    
    // define variables
    var moisture: Int {
        if _moisture == nil {
            _moisture = 0
        }
        return _moisture
    }
    
    var received: Bool {
        if _received == nil {
            _received = false
        }
        return _received
    }
    
    // download local sensor data from local server by Alamofire
    func downloadLocalMoistureDetails(completed: @escaping DownloadComplete) {
        // Alamofire download
        
        let localMoistURL = URL(string: CURRENT_LOCAL_MOIST_DATABASE_URL_3)!
        Alamofire.request(localMoistURL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                var lastMoist: Int = 0
                self._received = true
                
                if let currentMoist = dict["moisture"] as? Int { // get moisture
                    lastMoist = currentMoist
                }
                
                self._moisture = lastMoist/10
            }
            completed()
        }
        
    }
}


