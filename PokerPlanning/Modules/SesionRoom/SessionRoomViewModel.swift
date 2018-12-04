//
//  SessionRoomViewModel.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import RxSwift
import RxCocoa

class SessionRoomViewModel {
    
    let users: Driver<[String]>
    let tasks: Driver<[Task]>
    let currentTask: Driver<String>
    
    init(roomID: String, repository: PlanningRepository) {
        
        let room = repository
            .listenRoom(roomID)
        
        self.users = room.map { $0.users }
            .asDriver(onErrorJustReturn: [])
        
        self.tasks = repository.listenTasks(forRoomID: roomID)
            .debug("tasks")
            .asDriver(onErrorJustReturn: [])
        
        self.currentTask = room
            .map { $0.currentTask }
            .asDriver(onErrorJustReturn: "")
    }
}
