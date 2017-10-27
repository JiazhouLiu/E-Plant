//
//  LocalTemperature3.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import Alamofire

class LocalTemperature3: NSObject {
    var _temperature: Double!
    var _pressure: Double!
    var _received: Bool!
    
    var temperature: Double {
        if _temperature == nil {
            _temperature = 0.0
        }
        return _temperature
    }
    
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    
    
    var received: Bool {
        if _received == nil {
            _received = false
        }
        return _received
    }
    
    
    func downloadLocalWeatherDetails(completed: @escaping DownloadComplete) {
        // Alamofire download
        
        let localTempURL = URL(string: CURRENT_LOCAL_TEMP_DATABASE_URL_3)!
        Alamofire.request(localTempURL).responseJSON { response in
            let result = response.result
            //print(result.value)
            if let dict = result.value as? Dictionary<String, AnyObject> {
                var lastTemp: Double = 0.0
                var lastPress: Double = 0.0
                self._received = true
                
                if let currentTemperature = dict["temperature"] as? Double {
                    print(currentTemperature)
                    lastTemp = currentTemperature
                }
                if var currentPressure = dict["pressure"] as? Double{
                    currentPressure = (currentPressure * 100).rounded() / 100
                    lastPress = currentPressure
                }
                
                
                self._temperature = lastTemp
                self._pressure = lastPress
            }
            completed()
        }
        
    }
}


