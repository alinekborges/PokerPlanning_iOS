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

enum AppAction {
    case finishUsername
}

protocol AppActionable: class {
    func handle(_ action: AppAction)
}

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let container: Container
    lazy var storage: LocalStorage = {
        container.resolve(LocalStorage.self)!
    }()
    
    var mainCoordinator: MainCoordinator?
    
    var navigationController = UINavigationController()
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        
        self.window.rootViewController = navigationController
    }
    
    func start() {
        
        self.storage.clear()
        
        if storage.username.isEmpty {
            showUsernameView()
        } else {
            showMainView()
        }
        
//        if !storage.isLoggedIn {
//            showOnboarding()
//        } else {
//            showMainView()
//        }
    }
    
    func push(view: UIViewController) {
        if self.navigationController.viewControllers.isEmpty {
            self.navigationController.viewControllers = [view]
        } else {
            self.navigationController.pushViewController(view, animated: true)
        }
    }

}

extension AppCoordinator: AppActionable {
    
    func handle(_ action: AppAction) {
        switch action {
        case .finishUsername:
            self.showMainView()
        }
    }
    
}

extension AppCoordinator {
    
    fileprivate func showOnboarding() {
        let view = container.resolve(OnboardingView.self)!
        view.delegate = self
        self.push(view: view)
    }
    
    fileprivate func showMainView() {
        self.mainCoordinator = MainCoordinator(window: self.window, container: self.container)
        mainCoordinator?.start()
    }
    
    fileprivate func showUsernameView() {
        let view = container.resolve(UsernameView.self)!
        view.delegate = self
        self.push(view: view)
    }
    
}
