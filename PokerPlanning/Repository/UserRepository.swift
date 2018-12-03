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
    
}
