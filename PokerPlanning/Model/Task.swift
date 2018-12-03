//
//  Task.swift
//  PokerPlanning
//
//  Created by Aline Borges on 02/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation

struct Task: Codable {
    let name: String
}

struct Vote: Codable {
    let vote: Int
    let username: String
}
