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
    
    func allRooms() -> Observable<[SessionRoom]> {
        return self.firestore
            .collection("rooms")
            .rx
            .listen()
            .mapArray(SessionRoom.self)
    }
    
    func createRoom(_ name: String) -> Observable<String> {
        return self.firestore
            .collection("rooms")
            .document(name)
            .rx
            .setData(["users": [], "id": name, "currentTask": ""])
            .map { _ in return name } 
        
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
            }.do(onNext: { _ in self.storage.currentRoom = name })
            
    }
    
    func listenRoom(_ name: String) -> Observable<SessionRoom> {
        
        return self.firestore
            .collection("rooms")
            .document(name)
            .rx
            .listen()
            .map(SessionRoom.self)
            .unwrap()
        
    }
    
    func getTasks(forRoomID id: String) -> Observable<[Task]> {
        
        return self.firestore
            .collection("rooms")
            .document(id)
            .collection("tasks")
            .rx
            .getDocuments()
            .mapArray(Task.self)
        
    }
    
    func addTask(_ name: String, room: String) -> Observable<String> {
        
        let data: [String: Any] = ["description": name,
                    "completed": false]
        
        return self.firestore
            .collection("rooms")
            .document(room)
            .collection("tasks")
            .rx
            .addDocument(data: data)
            .map { $0.documentID }
            .flatMap { self.setCurrentTask(room: room, task: $0) }
        
    }
    
    //Enter a task and leave username there for counting
    func enterTask(_ taskID: String, room: String) -> Observable<Void> {
        
        return self.firestore
            .collection("rooms")
            .document(room)
            .collection("tasks")
            .document(taskID)
            .collection("votes")
            .document(self.username)
            .rx
            .setData(["username": self.username], merge: true)
            .map { _ in () }
    }
    
    func listenTask(_ taskID: String, roomID: String) -> Observable<Task> {
        return self.firestore
            .collection("rooms")
            .document(roomID)
            .collection("tasks")
            .document(taskID)
            .rx
            .listen()
            .map(Task.self)
            .unwrap()
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
    
    func completeTask(_ taskID: String, roomID: String, vote: Int) -> Observable<Void> {
        
        return self.firestore
            .collection("rooms")
            .document(roomID)
            .rx
            .setData(["currentTask": ""], merge: true)
            .flatMap {
                return self.firestore
                    .collection("rooms")
                    .document(roomID)
                    .collection("tasks")
                    .document(taskID)
                    .rx
                    .updateData(["completed": true, "vote": vote])
                    .map { _ in () }
        }

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
        if !users.contains(username) {
            users.append(username)
        }
        
        let data: [String: Any] = ["users": users, "id": roomName]
        
        return self.firestore
            .collection("rooms")
            .document(roomName)
            .rx
            .setData(data, merge: true)
        
    }
    
    private func setCurrentTask(room: String, task: String) -> Observable<String> {
        
        return self.firestore
            .collection("rooms")
            .document(room)
            .rx
            .setData(["currentTask": task], merge: true)
            .map { _ in return task }
        
    }
    
}
