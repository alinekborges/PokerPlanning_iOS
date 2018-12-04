//
//  AppDelegate.swift
//  PokerPlanning
//
//  Created by Aline Borges on 07/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import Firebase
import TouchVisualizer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaultContainer: DefaultContainer!
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Visualizer.start()
        
        Auth.auth().signInAnonymously { (result, error) in
            let user = result?.user
            print(user?.uid)
        }
        
        self.window?.tintColor = #colorLiteral(red: 0.9995236993, green: 0.4772071242, blue: 0.479349196, alpha: 1)
        
        self.defaultContainer = DefaultContainer()
        
        let currentWindow = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: currentWindow, container: defaultContainer.container)
        self.appCoordinator?.start()
        self.window = currentWindow
        self.window?.makeKeyAndVisible()
        
        return true
    }

}
