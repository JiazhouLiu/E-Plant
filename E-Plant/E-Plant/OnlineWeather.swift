//
//  OnlineWeather.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import Alamofire

class OnlineWeather: NSObject {
    var _temperature: Double!
    var _pressure: Double!
    var _weather: String!
    
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
    
    var weather: String {
        if _weather == nil {
            _weather = "Clear"
        }
        return _weather
    }
    
    func downloadOnlineWeatherDetails(completed: @escaping DownloadComplete) {
        // Alamofire download
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        Alamofire.request(currentWeatherURL).responseJSON { response in
            
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToCelciusProDivision = (currentTemperature - 273.15)
                        
                        let kelvinToCelcius = Double(round(10 * kelvinToCelciusProDivision/10))
                        self._temperature = kelvinToCelcius
                    }
                    
                    if let currentPressure = main["pressure"] as? Double {
                        let hpaToKpa = (currentPressure * 100).rounded() / 1000
                        self._pressure = hpaToKpa
                    }
                }
                if let apiWeather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let currentWeather = apiWeather[0]["main"] as? String {
                        self._weather = currentWeather
                    }
                }
            }
            completed()
        }
    }
}

