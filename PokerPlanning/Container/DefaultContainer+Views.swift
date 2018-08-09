//
//  DefaultContainer+Views.swift
//  PokerPlanning
//
//  Created by Aline Borges on 09/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import Swinject

//Register Views
extension DefaultContainer {
    
    func registerViews() {

        self.container.register(OnboardingView.self) { _ in
            OnboardingView()
        }

    }
    
}
