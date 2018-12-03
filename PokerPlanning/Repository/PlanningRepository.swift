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
    func getTasks(forRoomID id: String) -> Observable<[Task]>
    func addTask(_ name: String, room: String) -> Observable<String>
    
}
