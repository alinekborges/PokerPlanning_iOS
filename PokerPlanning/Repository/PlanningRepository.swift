//
//  UserRepository.swift
//  PokerPlanning
//
//  Created by Aline Borges on 02/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import RxSwift

protocol PlanningRepository {
    
    func setUsername(_ username: String) -> Observable<Void>
    func allRooms() -> Observable<[SessionRoom]>
    func enterRoom(_ name: String) -> Observable<SessionRoom>
    func createRoom(_ name: String) -> Observable<String>
    func listenRoom(_ name: String) -> Observable<SessionRoom>
    func listenTasks(forRoomID id: String) -> Observable<[Task]>
    func addTask(_ name: String, room: String) -> Observable<String>
    func listenVotes(task: String, room: String) -> Observable<[Vote]>
    func addVote(toTask taskID: String, room: String, vote: Int) -> Observable<Void>
    func enterTask(_ taskID: String, room: String) -> Observable<Void>
    func completeTask(_ taskID: String, roomID: String, vote: Int) -> Observable<Void>
    func listenTask(_ taskID: String, roomID: String) -> Observable<Task>
    
}
