//
//  FirebaseUserRepository.swift
//  PokerPlanning
//
//  Created by Aline Borges on 02/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import Firebase
import RxFirebase
import RxSwift

enum AuthError: Error {
    case login
}

class FirebasePlanningRepository: PlanningRepository {
    
    let firestore: Firestore
    let user: User?
    let storage: LocalStorage
    
    var username: String {
        return storage.username
    }
    
    init(firestore: Firestore = Firestore.firestore(),
         user: User? = Auth.auth().currentUser,
         storage: LocalStorage = LocalStorageImpl()) {
        self.storage = storage
        self.firestore = firestore
        self.user = user
    }
    
    func setUsername(_ username: String) -> Observable<Void> {
        guard let user = self.user else { return .error(AuthError.login) }
        
        return self.firestore
            .collection("users")
            .document(user.uid)
            .rx
            .setData(["username": username])
            .do(onNext: { self.storage.username = username })
            
    }
    
    func enterRoom(_ name: String) -> Observable<SessionRoom> {
        
        return self.firestore
            .collection("rooms")
            .document(name)
            .rx
            .getDocument()
            .map(SessionRoom.self)
            .unwrap()
            .flatMap { session in
                return self.addUserToRoom(roomName: name,
                                          session: session,
                                          username: self.storage.username)
                    .map { _ in session}
        }
            
    }
    
    func addTask(_ name: String, room: String) -> Observable<String> {
        
        let data = ["name": name]
        
        return self.firestore
            .collection("rooms")
            .document(room)
            .collection("tasks")
            .rx
            .addDocument(data: data)
            .map { $0.documentID }
        
    }
    
    func addVote(toTask taskID: String, room: String, vote: Int) -> Observable<Void> {
        
        return self.firestore
            .collection("rooms")
            .document(room)
            .collection("tasks")
            .document(taskID)
            .collection("votes")
            .document(self.username)
            .rx
            .setData(["vote": vote, "username": self.username])
            .map { _ in () }
        
    }
    
    func listenVotes(task: String, room: String) -> Observable<[Vote]> {
        
        return self.firestore
            .collection("rooms")
            .document(room)
            .collection("tasks")
            .document(task)
            .collection("votes")
            .rx
            .listen()
            .mapArray(Vote.self)

    }
    
    func listenTasks(room: String) -> Observable<[Task]> {
        
        return self.firestore
            .collection("rooms")
            .document(room)
            .collection("tasks")
            .rx
            .listen()
            .mapArray(Task.self)
        
    }
    
    private func addUserToRoom(roomName: String, session: SessionRoom, username: String) -> Observable<Void> {
        
        var users = session.users
        users.append(username)
        
        let data: [String: Any] = ["users": users]
        
        return self.firestore
            .collection("rooms")
            .document(roomName)
            .rx
            .setData(data, merge: true)
        
    }
    
}
