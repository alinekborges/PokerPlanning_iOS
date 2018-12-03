//
//  UsernameViewModel.swift
//  PokerPlanning
//
//  Created by Aline Borges on 02/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt

class UsernameViewModel {
    
    let validUsername: Driver<Bool>
    let onSuccess: Driver<Void>
    let onError: Driver<String>
    
    init(repository: PlanningRepository, username: Observable<String>, loginTap: Observable<Void>) {
        
        let isusernameValid = username
            .map { $0.count > 3 }
        
        self.validUsername = isusernameValid
            .asDriver(onErrorJustReturn: false)
        
        let result = loginTap
            .withLatestFrom(validUsername)
            .filter { $0 }
            .withLatestFrom(username)
            .flatMap {
                repository.setUsername($0)
                .materialize()
        }.share()
        
        self.onSuccess = result
            .elements()
            .asDriver(onErrorJustReturn: ())
        
        self.onError = result
            .errors()
            .map { $0.localizedDescription }
            .asDriver(onErrorJustReturn: "Erro inesperado")
    }
}
