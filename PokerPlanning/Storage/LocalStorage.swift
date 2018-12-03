//
//  LocalStorage.swift
//  PokerPlanning
//
//  Created by Aline Borges on 11/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import RxSwift

protocol LocalStorage: class {
    var username: String { get set }
    var currentRoom: String { get set }
    
    func clear()
}
