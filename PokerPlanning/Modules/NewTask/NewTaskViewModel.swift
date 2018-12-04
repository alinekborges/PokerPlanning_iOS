//
//  NewTaskViewModel.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import RxSwift
import RxCocoa

class NewTaskViewModel {
    
    let validTaskName: Driver<Bool>
    let onSuccess: Driver<String>
    let onError: Driver<String>
    
    init(roomID: String,
         repository: PlanningRepository,
         taskDescription: Observable<String>,
         buttonTap: Observable<Void>) {
        
        let isTaskValid = taskDescription
            .map { $0.count > 2 }
        
        self.validTaskName = isTaskValid
            .debug("isValid")
            .asDriver(onErrorJustReturn: false)
        
        let result = buttonTap
            .withLatestFrom(validTaskName)
            .filter { $0 }
            .withLatestFrom(taskDescription)
            .flatMap {
                repository.addTask($0, room: roomID)
                .materialize()
            }.share()
        
        self.onSuccess = result
            .elements()
            .asDriver(onErrorJustReturn: "")
        
        self.onError = result
            .errors()
            .map { $0.localizedDescription }
            .asDriver(onErrorJustReturn: "Erro inesperado")
        
    }
}
