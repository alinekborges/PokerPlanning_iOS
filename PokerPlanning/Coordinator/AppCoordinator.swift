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
    case finishRoom(selected: SessionRoom)
    case newTask
    case voting(taskID: String)
    case finishVoting
    case leaveSession
    case back
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
    
    var currentRoom: String = ""
    
    var navigationController = CustomNavigationController()
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        
        self.window.rootViewController = navigationController
    }
    
    func start() {

        //self.storage.clear()
        
        if storage.username.isEmpty {
            showUsernameView()
        } else if storage.currentRoom.isEmpty {
            showEnterRoom()
        } else {
            //FIX
            showEnterRoom()
            //showSessionRoom(id: storage.currentRoom)
        }

    }
    
    func push(view: UIViewController) {
        
        if self.navigationController.viewControllers.isEmpty {
            self.navigationController.viewControllers = [view]
        } else {
            self.navigationController.pushViewController(view, animated: true)
        }
        view.title = ""
    }

}

extension AppCoordinator: AppActionable {
    
    func handle(_ action: AppAction) {
        switch action {
        case .finishUsername:
            self.showEnterRoom()
        case .finishRoom(let selected):
            showSessionRoom(id: selected.id)
            self.currentRoom = selected.id
        case .newTask:
            showNewTask()
        case .voting(let taskID):
            showVotingTask(task: taskID)
        case .finishVoting:
            self.navigationController.dismiss(animated: true, completion: nil)
            if navigationController.topViewController is NewTaskView {
                navigationController.popViewController(animated: false)
            }
        case .leaveSession:
            self.storage.currentRoom = ""
            self.start()
        case .back:
            self.navigationController.popViewController(animated: false)
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
    
    fileprivate func showEnterRoom() {
        let view = container.resolve(EnterRoomView.self)!
        view.delegate = self
        self.push(view: view)
    }
    
    fileprivate func showSessionRoom(id: String) {
        let view = SessionRoomView(roomID: id)
        view.delegate = self
        self.push(view: view)
    }
    
    fileprivate func showNewTask() {
        let view = NewTaskView(roomID: self.currentRoom)
        view.delegate = self
        self.push(view: view)
    }
    
    fileprivate func showVotingTask(task: String) {
        let view = VotingTaskView(roomID: self.currentRoom, taskID: task)
        view.delegate = self
        self.navigationController.present(view, animated: true, completion: nil)
    }
    
}
