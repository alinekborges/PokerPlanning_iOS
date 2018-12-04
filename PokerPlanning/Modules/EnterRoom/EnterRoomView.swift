//
//  EnterRoomView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EnterRoomView: UIViewController {
    
    var viewModel: EnterRoomViewModel!
    
    let repository: PlanningRepository
    
    weak var delegate: AppActionable?
    
    let loading = DefaultLoadingView()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var newRoomButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    init(repository: PlanningRepository) {
        self.repository = repository
        super.init(nibName: String(describing: EnterRoomView.self), bundle: nil)
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

extension EnterRoomView {
    
    func setupViewModel() {
        
        let roomName = self.textField.rx.text.orEmpty.asObservable()
        let selectedRoom = self.tableView.rx.modelSelected(SessionRoom.self).asObservable()
        
        self.viewModel = EnterRoomViewModel(
            repository: self.repository,
            roomName: roomName,
            buttonTap: self.newRoomButton.rx.tap.asObservable(),
            selectedRoom: selectedRoom)
    }
    
    func configureViews() {
        self.tableView.register(UINib(nibName: "SessionCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 100
        self.tableView.separatorStyle = .none
        //self.tableView.register(SessionCell.self, forCellReuseIdentifier: "cell")
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(_:)))
        //self.view.addGestureRecognizer(gesture)
    }
    
    @objc func closeKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func setupBindings() {
        self.viewModel.rooms
            .drive(self.tableView.rx
                .items(cellIdentifier: "cell",
                       cellType: SessionCell.self)) { _, element, cell in
                    cell.bind(element)
            }.disposed(by: rx.disposeBag)
        
        self.viewModel.onSuccess
            .drive(onNext: { [weak self] selected in
                self?.delegate?.handle(.finishRoom(selected: selected))
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.validRoomName
            .drive(self.newRoomButton.rx.isUserInteractionEnabled)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.validRoomName
            .map { $0 ? 1.0 : 0.4 }
            .drive(self.newRoomButton.rx.alpha)
            .disposed(by: rx.disposeBag)
        
        self.viewModel.onError
            .drive(onNext: { [weak self] error in
                self?.showAlert(title: "Error!", message: error)
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.isLoading
            .drive(self.loading.rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        self.newRoomButton.rx.tap.bind { [weak self] in
            self?.view.endEditing(true)
        }.disposed(by: rx.disposeBag)
    }
}

class SessionTableViewCell: UITableViewCell {
    
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
