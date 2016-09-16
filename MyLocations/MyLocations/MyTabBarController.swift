//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Seab on 9/10/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return nil
    }
}