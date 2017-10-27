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

// Dashboard screen for plants
class Dashboard_PlantsVC: UIViewController {

    // IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var welcomingMsgLabel: UILabel!
    @IBOutlet weak var logOutBtn: UIBarButtonItem!
    @IBOutlet weak var customView1: UIView!
    @IBOutlet weak var customView2: UIView!
    @IBOutlet weak var customView3: UIView!
    
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
    
    
    
    // Activity Indicator
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customView1.layer.borderWidth = 1
        customView1.layer.borderColor = UIColor.init(red:52/255.0, green:63/255.0, blue:75/255.0, alpha: 1.0).cgColor
        customView2.layer.borderWidth = 1
        customView2.layer.borderColor = UIColor.init(red:52/255.0, green:63/255.0, blue:75/255.0, alpha: 1.0).cgColor
        customView3.layer.borderWidth = 1
        customView3.layer.borderColor = UIColor.init(red:52/255.0, green:63/255.0, blue:75/255.0, alpha: 1.0).cgColor
        logOutBtn.tintColor = UIColor.red
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    

}
