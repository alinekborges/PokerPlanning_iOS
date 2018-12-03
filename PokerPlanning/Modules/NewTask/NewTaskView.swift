//
//  NewTaskView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewTaskView: UIViewController {
    
    var viewModel: NewTaskViewModel!
    
    weak var delegate: AppActionable?
    
    let repository: PlanningRepository
    let roomID: String
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!

    init(roomID: String, repository: PlanningRepository = FirebasePlanningRepository()) {
        self.roomID = roomID
        self.repository = repository
        super.init(nibName: String(describing: NewTaskView.self), bundle: nil)
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

extension NewTaskView {
    
    func setupViewModel() {
        
        let task = self.textField.rx.text.orEmpty.asObservable()
        
        self.viewModel = NewTaskViewModel(
            roomID: self.roomID,
            repository: self.repository,
            taskDescription: task,
            buttonTap: self.button.rx.tap.asObservable())
    }
    
    func configureViews() {
        
    }
    
    func setupBindings() {
        self.viewModel.onSuccess
            .drive(onNext: { [weak self] id in
                //self?.delegate?.handle(.finishRoom(selected: selected))
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.onError
            .drive(onNext: { [weak self] error in
                self?.showAlert(title: "Error!", message: error)
            }).disposed(by: rx.disposeBag)
    }
}
