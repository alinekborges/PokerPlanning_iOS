//
//  DefaultContainer.swift
//  PokerPlanning
//
//  Created by Aline Borges on 09/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import Swinject
import Moya

final class DefaultContainer {
    
    let container: Container
    
    init() {
        self.container = Container()
        self.registerServices()
        self.registerViews()
        self.registerStorage()
    }
    
}

//Register Storage
extension DefaultContainer {
    
    func registerStorage() {
        
//        self.container.register(LocalStorage.self) { _ in
//            return LocalStorageImpl()
//        }
        
    }
    
}
