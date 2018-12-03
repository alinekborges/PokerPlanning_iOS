//
//  LocalStorageImpl.swift
//  PokerPlanning
//
//  Created by Aline Borges on 11/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import RxSwift

struct LocalStorageKeys {
    private init() {}
    
    static let username = "username"
    static let currentRoom = "current_room"
}

class LocalStorageImpl: LocalStorage {
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    var username: String {
        get {
            return userDefaults.string(forKey: LocalStorageKeys.username) ?? ""
        } set {
            userDefaults.set(newValue, forKey: LocalStorageKeys.username)
        }
    }
    
    var currentRoom: String {
        get {
            return userDefaults.string(forKey: LocalStorageKeys.currentRoom) ?? ""
        } set {
            userDefaults.set(newValue, forKey: LocalStorageKeys.currentRoom)
        }
    }
    
    func clear() {
        userDefaults.removeObject(forKey: LocalStorageKeys.username)
    }
    
}
