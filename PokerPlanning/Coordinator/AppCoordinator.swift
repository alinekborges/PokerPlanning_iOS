//
//  AppCoordinator.swift
//  PokerPlanning
//
//  Created by Aline Borges on 09/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import UIKit
import Swinject

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let container: Container
//    lazy var storage: LocalStorage = {
//        container.resolve(LocalStorage.self)!
//    }()
    
    var currentView: UIViewController? {
        get {
            return window.rootViewController
        }
        set {
            UIView.transition(with: self.window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.window.rootViewController = newValue
            }, completion: nil)
        }
    }
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }
    
    func start() {
        
//        if storage.firstAccess {
            showOnboarding()
//        } else {
//            showMainView()
//        }
    }
    
    fileprivate func showOnboarding() {
//        let view = container.resolve(OnboardingView.self)!
//        view.delegate = self
//        self.currentView = view
    }
    
    fileprivate func showMainView() {
//        let view = container.resolve(MainView.self)!
//        view.delegate = self
//        self.currentView = view
    }

}
