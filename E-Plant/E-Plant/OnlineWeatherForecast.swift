//
//  OnlineWeather.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation
import Alamofire

class OnlineWeatherForecast: NSObject {

    var _firstWeather: String!
    var _firstTempMin: Double!
    var _firstTempMax: Double!
    
    var _secondWeather: String!
    var _secondTempMin: Double!
    var _secondTempMax: Double!
    
    var _thirdWeather: String!
    var _thirdTempMin: Double!
    var _thirdTempMax: Double!
    
    var firstWeather: String {
        if _firstWeather == nil {
            _firstWeather = "Clear"
        }
        return _firstWeather
    }
    
    var firstTempMin: Double {
        if _firstTempMin == nil {
            _firstTempMin = 0.0
        }
        return _firstTempMin
    }
    
    var firstTempMax: Double {
        if _firstTempMax == nil {
            _firstTempMax = 0.0
        }
        return _firstTempMax
    }
    
    var secondWeather: String {
        if _secondWeather == nil {
            _secondWeather = "Clear"
        }
        return _secondWeather
    }
    
    var secondTempMin: Double {
        if _secondTempMin == nil {
            _secondTempMin = 0.0
        }
        return _secondTempMin
    }
    
    var secondTempMax: Double {
        if _secondTempMax == nil {
            _secondTempMax = 0.0
        }
        return _secondTempMax
    }
    
    var thirdWeather: String {
        if _thirdWeather == nil {
            _thirdWeather = "Clear"
        }
        return _thirdWeather
    }
    
    var thirdTempMin: Double {
        if _thirdTempMin == nil {
            _thirdTempMin = 0.0
        }
        return _thirdTempMin
    }
    
    var thirdTempMax: Double {
        if _thirdTempMax == nil {
            _thirdTempMax = 0.0
        }
        return _thirdTempMax
    }
    
    func downloadOnlineWeatherDetails(completed: @escaping DownloadComplete) {
        // Alamofire download
        let forecastWeatherURL = URL(string: FORECAST_WEATHER_URL)!
        Alamofire.request(forecastWeatherURL).responseJSON { response in
            
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    if let firstForecast = list[8] as? Dictionary<String, AnyObject>{
                        if let main = firstForecast["main"] as? Dictionary<String, AnyObject> {
                            if let curTempMin = main["temp_min"] as? Double {
                                let kelvinToCelciusProDivision = (curTempMin - 273.15)
                                
                                let kelvinToCelcius = Double(round(10 * kelvinToCelciusProDivision/10))
                                self._firstTempMin = kelvinToCelcius
                            }
                            
                            if let curTempMax = main["temp_max"] as? Double {
                                let kelvinToCelciusProDivision = (curTempMax - 273.15)
                                
                                let kelvinToCelcius = Double(round(10 * kelvinToCelciusProDivision/10))
                                self._firstTempMax = kelvinToCelcius
                            }
                        }
                        if let apiWeather = firstForecast["weather"] as? [Dictionary<String, AnyObject>] {
                            if let currentWeather = apiWeather[0]["main"] as? String {
                                self._firstWeather = currentWeather
                            }
                        }
                    }
                    
                    if let secondForecast = list[16] as? Dictionary<String, AnyObject>{
                        if let main = secondForecast["main"] as? Dictionary<String, AnyObject> {
                            if let curTempMin = main["temp_min"] as? Double {
                                let kelvinToCelciusProDivision = (curTempMin - 273.15)
                                
                                let kelvinToCelcius = Double(round(10 * kelvinToCelciusProDivision/10))
                                self._secondTempMin = kelvinToCelcius
                            }
                            
                            if let curTempMax = main["temp_max"] as? Double {
                                let kelvinToCelciusProDivision = (curTempMax - 273.15)
                                
                                let kelvinToCelcius = Double(round(10 * kelvinToCelciusProDivision/10))
                                self._secondTempMax = kelvinToCelcius
                            }
                        }
                        if let apiWeather = secondForecast["weather"] as? [Dictionary<String, AnyObject>] {
                            if let currentWeather = apiWeather[0]["main"] as? String {
                                self._secondWeather = currentWeather
                            }
                        }
                    }
                    
                    if let thirdForecast = list[24] as? Dictionary<String, AnyObject>{
                        if let main = thirdForecast["main"] as? Dictionary<String, AnyObject> {
                            if let curTempMin = main["temp_min"] as? Double {
                                let kelvinToCelciusProDivision = (curTempMin - 273.15)
                                
                                let kelvinToCelcius = Double(round(10 * kelvinToCelciusProDivision/10))
                                self._thirdTempMin = kelvinToCelcius
                            }
                            
                            if let curTempMax = main["temp_max"] as? Double {
                                let kelvinToCelciusProDivision = (curTempMax - 273.15)
                                
                                let kelvinToCelcius = Double(round(10 * kelvinToCelciusProDivision/10))
                                self._thirdTempMax = kelvinToCelcius
                            }
                        }
                        if let apiWeather = thirdForecast["weather"] as? [Dictionary<String, AnyObject>] {
                            if let currentWeather = apiWeather[0]["main"] as? String {
                                self._thirdWeather = currentWeather
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
}


