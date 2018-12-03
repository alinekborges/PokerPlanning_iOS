//
//  VotingTaskView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VotingTaskView: UIViewController {
    
    var viewModel: VotingTaskViewModel!
    
    weak var delegate: AppActionable?
    
    let roomID: String
    let taskID: String
    let repository: PlanningRepository
    
    var currentVote: Int = -1
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let vote = PublishSubject<Int>()
    
    init(roomID: String, taskID: String, repository: PlanningRepository = FirebasePlanningRepository()) {
        self.roomID = roomID
        self.taskID = taskID
        self.repository = repository
        super.init(nibName: String(describing: VotingTaskView.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.setupViewModel()
        self.setupBindings()
        
        self.viewModel.enterTask()
            .subscribe(onNext: {
                print("entered task")
            }).disposed(by: rx.disposeBag)
    }
    
    @IBAction func voteTap(_ sender: UIButton) {
        if let text = sender.titleLabel?.text, let vote = Int(text) {
            self.vote.onNext(vote)
            self.currentVote = vote
        }
    }
    
    @IBAction func voteTaskTap(_ sender: Any) {
        //TODO: show confirmation view 
        self.viewModel.completeTask(vote: currentVote)
            .subscribe(onNext: { [weak self] _ in
                //self?.delegate?.handle(.finishVoting)
            }).disposed(by: rx.disposeBag)
    }
    
}

extension VotingTaskView {
    
    func setupViewModel() {
        self.viewModel = VotingTaskViewModel(
            roomID: self.roomID,
            taskID: self.taskID,
            repository: self.repository,
            vote: self.vote.asObservable())
    }
    
    func configureViews() {
        self.tableView.register(VoteTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupBindings() {
        self.viewModel.votes
            .drive(self.tableView.rx
                .items(cellIdentifier: "cell",
                       cellType: UITableViewCell.self)) { _, element, cell in
                        var voteString = "???"
                        
                        if let vote = element.vote {
                            voteString = String(vote)
                        }

                        cell.textLabel?.text = "\(voteString) - \(element.username)"
                        //cell.detailTextLabel?.text = "Final vote: \(element.name)"
            }.disposed(by: rx.disposeBag)
        
        self.viewModel.votingCompleted
            .drive(self.finishButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.votingCompleted
            .map { $0 ? 1.0 : 0.4 }
            .drive(self.finishButton.rx.alpha)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.votingClosed
            .subscribe(onNext: { [weak self] in
                self?.delegate?.handle(.finishVoting)
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.didVote
            .drive(onNext: { _ in
                print("voted!!")
            }).disposed(by: rx.disposeBag)
    }
}

class VoteTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    init() {
        super.init(style: .subtitle, reuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
