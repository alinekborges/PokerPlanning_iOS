//
//  SessionRoomView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SessionRoomView: UIViewController {
    
    var viewModel: SessionRoomViewModel!
    
    weak var delegate: AppActionable?
    
    let repository: PlanningRepository
    let roomID: String

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cloudView: CloudTagView!
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    init(roomID: String, repository: PlanningRepository = FirebasePlanningRepository()) {
        self.repository = repository
        self.roomID = roomID
        super.init(nibName: String(describing: SessionRoomView.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.setupViewModel()
        self.setupBindings()
    }
    
}

extension SessionRoomView {
    
    func setupViewModel() {
        self.viewModel = SessionRoomViewModel(roomID: self.roomID, repository: self.repository)
    }
    
    func configureViews() {
        self.cloudView.tagBackgroundColor = .slate
        self.cloudView.textColor = .white
        self.tableView.register(UINib(nibName: "TaskCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 80
        self.tableView.separatorStyle = .none
        self.titleLabel.text = self.roomID
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sair",
            style: .plain,
            target: self,
            action: #selector(self.leaveSession(_:)))
    }
    
    @objc func leaveSession(_ sender: Any) {
        self.delegate?.handle(.leaveSession)
    }
    
    func setupBindings() {
        self.viewModel.users
            .drive(self.cloudView.rx.items)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.tasks
            .drive(self.tableView.rx
                .items(cellIdentifier: "cell",
                       cellType: TaskCell.self)) { _, element, cell in
                        cell.bind(element)
            }.disposed(by: rx.disposeBag)
        
        self.newTaskButton.rx.tap.bind { [weak self] _ in
            self?.delegate?.handle(.newTask)
        }.disposed(by: rx.disposeBag)
        
        self.viewModel.currentTask
            .drive(onNext: { [weak self] task in
                //TODO: show alert before going to other screen
                if !task.isEmpty {
                    //self?.delegate?.handle(.voting(taskID: task))
                    print("go to task")
                    self?.showAlert(title: "Task", message: "task", completion: { _ in
                        self?.delegate?.handle(.voting(taskID: task))
                    })
                    
                }
            }).disposed(by: rx.disposeBag)
        
    }
}

class TaskTableViewCell: UITableViewCell {
    
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
