//
//  MainCoordinator.swift
//  PokerPlanning
//
//  Created by Aline Borges on 11/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import UIKit
import Swinject

class MainCoordinator: Coordinator {
    
    let window: UIWindow?
    let container: Container
    var navigationController: UINavigationController?
    
    init(window: UIWindow?, container: Container) {
        self.window = window
        self.container = container
        
    }
    
    func start() {
        showMainView()
    }
    
    func showMainView() {
        let mainView = container.resolve(MainView.self)!
        navigationController = UINavigationController(rootViewController: mainView)
        self.window?.rootViewController = navigationController
    }
    
}
