//
//  VotingTaskViewModel.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import RxSwift
import RxCocoa

class VotingTaskViewModel {
    
    let votes: Driver<[Vote]>
    let didVote: Driver<Bool>
    let votingCompleted: Driver<Bool>
    let votingClosed: Observable<Void>
    let title: Driver<String>
    
    let repository: PlanningRepository
    let roomID: String
    let taskID: String
    
    init(roomID: String,
         taskID: String,
         repository: PlanningRepository,
         vote: Observable<Int>) {
        self.roomID = roomID
        self.taskID = taskID
        self.repository = repository
        
        let votesArray = repository
            .listenVotes(task: taskID, room: roomID)
            .share()
        
        let votingCompleted = votesArray
            .map { $0.contains(where: { $0.vote == nil }) }
            .map { !$0 }
        
        self.votingCompleted = votingCompleted
            .asDriver(onErrorJustReturn: false)
        
        let currentTask = repository.listenTask(taskID, roomID: roomID)
        
        self.votingClosed = currentTask
            .filter { $0.completed }
            .map { _ in () }
        
        self.title = currentTask
            .map { $0.description }
            .asDriver(onErrorJustReturn: "")
        
        let voteMapper: (([Vote], Bool) -> [Vote]) = { votesArray, votingCompleted in
            return votesArray.map { vote -> Vote in
                let number = votingCompleted ? vote.vote : nil
                return Vote(username: vote.username, vote: number) }
        }
        
        self.votes = Observable.combineLatest(votesArray, votingCompleted)
            .map(voteMapper)
            .asDriver(onErrorJustReturn: [])
        
        self.didVote = vote
            .flatMap { vote in
                repository.addVote(toTask: taskID, room: roomID, vote: vote)
            }.map { _ in true }
            .asDriver(onErrorJustReturn: false)
        
    }
    
    func enterTask() -> Observable<Void> {
        return self.repository.enterTask(self.taskID, room: self.roomID)
    }
    
    func completeTask(vote: Int) -> Observable<Void> {
        return self.repository.completeTask(taskID, roomID: roomID, vote: vote)
    }
}
