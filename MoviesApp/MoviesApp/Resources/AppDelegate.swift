//
//  AppDelegate.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Initialize
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        navigationController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = navigationController
    
        return true
    }
}

