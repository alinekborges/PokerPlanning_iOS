//
//  EnterRoomViewModel.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import RxSwift
import RxCocoa

class EnterRoomViewModel {
    
    let rooms: Driver<[SessionRoom]>
    let validRoomName: Driver<Bool>
    let onSuccess: Driver<SessionRoom>
    let onError: Driver<String>
    
    init(repository: PlanningRepository,
         roomName: Observable<String>,
         buttonTap: Observable<Void>,
         selectedRoom: Observable<SessionRoom>) {
        
        self.rooms = repository
            .allRooms()
            .debug()
            .asDriver(onErrorJustReturn: [])
        
        let isRoomnameValid = roomName
            .map { $0.count > 3 }
        
        self.validRoomName = isRoomnameValid
            .asDriver(onErrorJustReturn: false)
        
        let newRoom = buttonTap
            .withLatestFrom(validRoomName)
            .filter { $0 }
            .withLatestFrom(roomName)
            .flatMap(repository.createRoom)
        
        let selected = selectedRoom.map { $0.id }
        
        let result = Observable.merge(newRoom, selected)
            .flatMap {
                repository.enterRoom($0)
                .materialize()
            }.share()
        
        self.onSuccess = result
            .elements()
            .asDriver(onErrorJustReturn: SessionRoom())
        
        self.onError = result
            .errors()
            .map { $0.localizedDescription }
            .asDriver(onErrorJustReturn: "Erro inesperado")
    }
}
