//
//  Constants.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "9e9e94e8d65a1f2f634b77345ca3a174"

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"

typealias DownloadComplete = () -> ()

let LOCAL_HTTP = "http://"
let LOCAL_IP = "172.20.10.10"
let LOCAL_PORT = ":8080/"
let LOCAL_TEMP_PATH = "public/CurrentTemp.json"
let LOCAL_MOIST_PATH = "public/CurrentMoist.json"

let CURRENT_LOCAL_TEMP_DATABASE_URL = "\(LOCAL_HTTP)\(LOCAL_IP)\(LOCAL_PORT)\(LOCAL_TEMP_PATH)"
let CURRENT_LOCAL_MOIST_DATABASE_URL = "\(LOCAL_HTTP)\(LOCAL_IP)\(LOCAL_PORT)\(LOCAL_MOIST_PATH)"
