//
//  MainTBC.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 4/11/17.
//  Copyright © 2017 Monash University. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self // delegate to self controller
        // Do any additional setup after loading the view.
    }

    // select tab bar item to go to top hierarchy view
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if let vc = viewController as? UINavigationController {
//            vc.popViewController(animated: false);
//        }
    }

}
