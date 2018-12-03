//
//  SessionRoom.swift
//  PokerPlanning
//
//  Created by Aline Borges on 02/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation

struct SessionRoom: Codable {
    let users: [String]
    let id: String
    
    init(users: [String] = [], id: String = "Erro!") {
        self.users = users
        self.id = id
    }
}
