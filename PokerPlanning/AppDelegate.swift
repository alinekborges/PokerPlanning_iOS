//
//  AppDelegate.swift
//  PokerPlanning
//
//  Created by Aline Borges on 07/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaultContainer: DefaultContainer!
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Auth.auth().signInAnonymously { (result, error) in
            let user = result?.user
            print(user?.uid)
        }
        
        print(Auth.auth().currentUser?.uid)
        
        self.defaultContainer = DefaultContainer()
        
        let currentWindow = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: currentWindow, container: defaultContainer.container)
        self.appCoordinator?.start()
        self.window = currentWindow
        self.window?.makeKeyAndVisible()
        
        return true
    }

}
