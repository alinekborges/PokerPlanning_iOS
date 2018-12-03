//
//  DefaultContainer.swift
//  PokerPlanning
//
//  Created by Aline Borges on 09/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import Swinject


final class DefaultContainer {
    
    let container: Container
    
    init() {
        self.container = Container()
        self.registerViews()
        self.registerStorage()
        self.registerRepository()
    }
    
}

//Register Storage
extension DefaultContainer {
    
    func registerStorage() {
        
        self.container.register(LocalStorage.self) { _ in
            return LocalStorageImpl()
        }
        
    }
    
}

extension DefaultContainer {
    
    func registerRepository() {
        
        self.container.register(PlanningRepository.self) { _ in
            return FirebasePlanningRepository()
        }
        
    }
    
}
