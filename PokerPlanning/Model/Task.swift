//
//  Task.swift
//  PokerPlanning
//
//  Created by Aline Borges on 02/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation

struct Task: Codable {
    let description: String
    let completed: Bool
    let vote: Int?
    
    init(description: String = "") {
        self.description = description
        self.completed = false
        self.vote = nil
    }
}

struct Vote: Codable {
    let vote: Int?
    let username: String
    
    init(username: String, vote: Int? = nil) {
        self.vote = vote
        self.username = username
    }
}

struct VoteDisplay {
    let hasVote: Bool = false
}
