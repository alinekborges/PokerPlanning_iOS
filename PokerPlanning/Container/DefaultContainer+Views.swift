//
//  DefaultContainer+Views.swift
//  PokerPlanning
//
//  Created by Aline Borges on 09/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import Swinject

extension DefaultContainer {
    
    func registerViews() {

        self.container.register(OnboardingView.self) { _ in
            OnboardingView()
        }
        
        self.container.register(LoginView.self) { _ in
            LoginView()
        }
        
        self.container.register(MainView.self) { _ in
            MainView()
        }
        
        self.container.register(UsernameView.self) { resolver in
            return UsernameView(repository: resolver.resolve(PlanningRepository.self)!)
        }

    }
    
}
