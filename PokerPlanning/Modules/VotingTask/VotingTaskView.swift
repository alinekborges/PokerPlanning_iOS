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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var votingButtons: [VotingButton]!
    
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
    
    @IBAction func voteTap(_ sender: VotingButton) {
        if let text = sender.titleLabel?.text, let vote = Int(text) {
            self.vote.onNext(vote)
            self.currentVote = vote
            self.votingButtons.forEach { $0.setState(false) }
            sender.setState(true)
        }
    }
    
    @IBAction func voteTaskTap(_ sender: Any) {
        //TODO: show confirmation view 
        self.viewModel.completeTask(vote: currentVote)
            .subscribe()
            .disposed(by: rx.disposeBag)
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
        self.tableView.register(UINib(nibName: "VoteCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 52
        self.tableView.separatorStyle = .none
        
    }
    
    func setupBindings() {
        self.viewModel.votes
            .drive(self.tableView.rx
                .items(cellIdentifier: "cell",
                       cellType: VoteCell.self)) { _, element, cell in
                        cell.bind(element)
            }.disposed(by: rx.disposeBag)
        
        self.viewModel.finishEnabled
            .drive(self.finishButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.finishEnabled
            .map { $0 ? 1.0 : 0.0 }
            .drive(self.finishButton.rx.alpha)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.votingClosed
            .subscribe(onNext: { [weak self] in
                self?.finishVoting()
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.didVote
            .drive()
            .disposed(by: rx.disposeBag)
        
        self.viewModel.title
            .drive(self.descriptionLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
    
    func finishVoting() {
        let alert = AlertView(title: "Votação finalizada! Nota final: \(self.currentVote)") {
            self.delegate?.handle(.finishVoting)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
