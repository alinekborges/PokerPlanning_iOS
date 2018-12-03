//
//  UsernameView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 02/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsernameView: UIViewController {
    
    var viewModel: UsernameViewModel!
    let repository: PlanningRepository
    
    weak var delegate: AppActionable?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    init(repository: PlanningRepository) {
        self.repository = repository
        super.init(nibName: String(describing: UsernameView.self), bundle: nil)
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

extension UsernameView {
    
    func setupViewModel() {
        
        let username = self.usernameTextField.rx.text.orEmpty.asObservable()
        
        self.viewModel = UsernameViewModel(
            repository: self.repository,
            username: username,
            loginTap: self.loginButton.rx.tap.asObservable())
    }
    
    func configureViews() {
        
    }
    
    func setupBindings() {
        self.viewModel.onSuccess
            .drive(onNext: { _ in
                self.delegate?.handle(.finishUsername)
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.onError
            .drive(onNext: { [weak self] error in
                self?.showAlert(title: "Error!", message: error)
            }).disposed(by: rx.disposeBag)
    }
}
