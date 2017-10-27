//
//  Dashboard_PlantsVC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 27/10/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

// Dashboard screen for plants
class Dashboard_PlantsVC: UIViewController, CLLocationManagerDelegate {

    // IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var welcomingMsgLabel: UILabel!
    @IBOutlet weak var logOutBtn: UIBarButtonItem!
    @IBOutlet weak var customView1: UIView!
    @IBOutlet weak var customView2: UIView!
    @IBOutlet weak var customView3: UIView!
    
    // plants segment labels
    @IBOutlet weak var currentPlantNumLabel: UILabel!
    @IBOutlet weak var currentPlantNumFixedLabel: UILabel!
    @IBOutlet weak var healthyPlantNumLabel: UILabel!
    @IBOutlet weak var healthyPlantNumFixedLabel: UILabel!
    @IBOutlet weak var warningPlantNumLabel: UIView!
    @IBOutlet weak var warningPlantNumFixedLabel: UILabel!
    @IBOutlet weak var dangerPlantNumLabel: UILabel!
    @IBOutlet weak var dangerPlantNumFixedLabel: UILabel!
    @IBOutlet weak var historyPlantNumLabel: UILabel!
    @IBOutlet weak var historyPlantNumFixedLabel: UILabel!
    
    // segment control
    @IBOutlet weak var dashboardSegment: UISegmentedControl!
    
    // water segment labels
    @IBOutlet weak var todayUsageFixedLabel: UILabel!
    @IBOutlet weak var todayUsageLabel: UILabel!
    @IBOutlet weak var dailyAveUsageFixedLabel: UILabel!
    @IBOutlet weak var dailyAveUsageLabel: UILabel!
    @IBOutlet weak var monthlyUsageFixedLabel: UILabel!
    @IBOutlet weak var monthlyUsageLabel: UILabel!
    
    // top right weather info
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    // background Image
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    // Activity Indicator
    var spinner: UIActivityIndicatorView!
    
    // weather variables
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var timerStarted = false
    var onlineWeather: OnlineWeather!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set view border for UI good looking
        customView1.layer.borderWidth = 1
        customView1.layer.borderColor = UIColor.init(red:52/255.0, green:63/255.0, blue:75/255.0, alpha: 1.0).cgColor
        customView2.layer.borderWidth = 1
        customView2.layer.borderColor = UIColor.init(red:52/255.0, green:63/255.0, blue:75/255.0, alpha: 1.0).cgColor
        customView3.layer.borderWidth = 1
        customView3.layer.borderColor = UIColor.init(red:52/255.0, green:63/255.0, blue:75/255.0, alpha: 1.0).cgColor
        logOutBtn.tintColor = UIColor.red
        
        // location manager setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // check location service status
        locationAuthStatus()
        // refresh current date and print on screen
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let todayFormatter = DateFormatter()
        todayFormatter.dateFormat = "yyyy-MM-dd"
        let today = todayFormatter.string(from: date)
        let result = formatter.string(from: date)
        let DOW = getDayOfWeek(today: today)
        self.dateLabel.text = "\(DOW!) \(result)"
        
        // refresh current username and print welcoming message on screen
        self.welcomingMsgLabel.text = "Welcome back"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        // setup spinner
        self.spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        self.spinner.color = UIColor.lightGray
        self.spinner.center = CGPoint(x: self.view.frame.width / 2, y: 100)
        self.view.addSubview(spinner)
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        
        // get user attribute from database and display it in the top cell
        ref.child("users").child(userID!).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let displayName = value?["username"] as? String ?? ""
            self.spinner.stopAnimating()
            self.welcomingMsgLabel.text = "Welcome back, \(displayName)!"
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    //Date String Helper Functions -> day of the week
    func getDayOfWeek(today:String)->String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday!
            switch weekDay {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                print("Error fetching days")
                return "Day"
            }
        } else {
            return nil
        }
    }
    
    func startTimer(){
        if !timerStarted {
            _ = Timer.scheduledTimer(timeInterval: 1, target: self,selector: #selector(Dashboard_PlantsVC.refreshOnlineWeather), userInfo: nil, repeats: true)
            timerStarted = true
        }
    }
    
    func refreshOnlineWeather() {
        onlineWeather = OnlineWeather()
        onlineWeather.downloadOnlineWeatherDetails {
            self.updateOnlineUI()
        }
    }
    
    // check auth status to make request if needed
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            let lat = currentLocation.coordinate.latitude
            let long = currentLocation.coordinate.longitude
            if lat != nil && long != nil {
                Location.sharedInstance.latitude = lat
                Location.sharedInstance.longitude = long
            }else {
                Location.sharedInstance.latitude = -37.876398
                Location.sharedInstance.longitude = 145.0548502
            }
            startTimer()
        }else {
            locationManager.requestWhenInUseAuthorization()
            //locationAuthStatus()
        }
    }
    
    // if changed auth status then show user location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            startTimer()
        }
    }
    
    // update data
    func updateOnlineUI() {
        temperature.text = "\(onlineWeather.temperature) °C"
        weatherImage.image = UIImage(named: "\(onlineWeather.weather) Mini")
    }

    // log out button pressed
    @IBAction func logOutBtnPressed(_ sender: Any) {
        // run logout function from Firebase auth service
        if Auth.auth().currentUser != nil{
            AuthService.instance.logout()
        }
        
        // show user success message and navigate back to root screen
        let alertController = UIAlertController(title: "Success", message: "You have successfully logged out", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            if let storyboard = self.storyboard {
                let vc = storyboard.instantiateInitialViewController()
                self.present(vc!, animated: true, completion: nil)
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        if dashboardSegment.selectedSegmentIndex == 0 {
            showPlantSeg()
            
        }else if dashboardSegment.selectedSegmentIndex == 1{
            showWaterSeg()
        }
    }
    
    func showPlantSeg() {
        currentPlantNumLabel.isHidden = false
        currentPlantNumFixedLabel.isHidden = false
        healthyPlantNumLabel.isHidden = false
        healthyPlantNumFixedLabel.isHidden = false
        warningPlantNumLabel.isHidden = false
        warningPlantNumFixedLabel.isHidden = false
        dangerPlantNumLabel.isHidden = false
        dangerPlantNumFixedLabel.isHidden = false
        historyPlantNumLabel.isHidden = false
        historyPlantNumFixedLabel.isHidden = false
        
        todayUsageLabel.isHidden = true
        todayUsageFixedLabel.isHidden = true
        dailyAveUsageLabel.isHidden = true
        dailyAveUsageFixedLabel.isHidden = true
        monthlyUsageLabel.isHidden = true
        monthlyUsageFixedLabel.isHidden = true
        
        backgroundImage.image = #imageLiteral(resourceName: "plantsBackground")
    }
    
    func showWaterSeg() {
        currentPlantNumLabel.isHidden = true
        currentPlantNumFixedLabel.isHidden = true
        healthyPlantNumLabel.isHidden = true
        healthyPlantNumFixedLabel.isHidden = true
        warningPlantNumLabel.isHidden = true
        warningPlantNumFixedLabel.isHidden = true
        dangerPlantNumLabel.isHidden = true
        dangerPlantNumFixedLabel.isHidden = true
        historyPlantNumLabel.isHidden = true
        historyPlantNumFixedLabel.isHidden = true
        
        todayUsageLabel.isHidden = false
        todayUsageFixedLabel.isHidden = false
        dailyAveUsageLabel.isHidden = false
        dailyAveUsageFixedLabel.isHidden = false
        monthlyUsageLabel.isHidden = false
        monthlyUsageFixedLabel.isHidden = false
        
        backgroundImage.image = #imageLiteral(resourceName: "waterBackground")
    }

}
