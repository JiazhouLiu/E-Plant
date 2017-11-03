//
//  Constants.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let BASE_URL_FORECAST = "http://api.openweathermap.org/data/2.5/forecast?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "9e9e94e8d65a1f2f634b77345ca3a174"

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"
let FORECAST_WEATHER_URL = "\(BASE_URL_FORECAST)\(LATITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"

typealias DownloadComplete = () -> ()

let LOCAL_HTTP = "http://"
let LOCAL_IP = "172.20.10.10"
let LOCAL_PORT_1 = ":8080/"
let LOCAL_PORT_2 = ":591/"
let LOCAL_PORT_3 = ":8008/"
let LOCAL_TEMP_PATH = "public/CurrentTemp"
let LOCAL_MOIST_PATH = "public/CurrentMoist"
let LOCAL_FILE_EXT = ".json"

let CURRENT_LOCAL_TEMP_DATABASE_URL_1 = "\(LOCAL_HTTP)\(LOCAL_IP)\(LOCAL_PORT_1)\(LOCAL_TEMP_PATH)_1\(LOCAL_FILE_EXT)"
let CURRENT_LOCAL_TEMP_DATABASE_URL_2 = "\(LOCAL_HTTP)\(LOCAL_IP)\(LOCAL_PORT_2)\(LOCAL_TEMP_PATH)_2\(LOCAL_FILE_EXT)"
let CURRENT_LOCAL_TEMP_DATABASE_URL_3 = "\(LOCAL_HTTP)\(LOCAL_IP)\(LOCAL_PORT_3)\(LOCAL_TEMP_PATH)_3\(LOCAL_FILE_EXT)"
let CURRENT_LOCAL_MOIST_DATABASE_URL_1 = "\(LOCAL_HTTP)\(LOCAL_IP)\(LOCAL_PORT_1)\(LOCAL_MOIST_PATH)_1\(LOCAL_FILE_EXT)"
let CURRENT_LOCAL_MOIST_DATABASE_URL_2 = "\(LOCAL_HTTP)\(LOCAL_IP)\(LOCAL_PORT_2)\(LOCAL_MOIST_PATH)_2\(LOCAL_FILE_EXT)"
let CURRENT_LOCAL_MOIST_DATABASE_URL_3 = "\(LOCAL_HTTP)\(LOCAL_IP)\(LOCAL_PORT_3)\(LOCAL_MOIST_PATH)_3\(LOCAL_FILE_EXT)"
