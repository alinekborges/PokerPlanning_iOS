//
//  LoginView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 11/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginViewDelegate: class {
    
}

class LoginView: UIViewController {
    
    var viewModel: LoginViewModel!
    
    weak var delegate: LoginViewDelegate?

    init() {
        super.init(nibName: String(describing: LoginView.self), bundle: nil)
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

extension LoginView {
    
    func setupViewModel() {
        self.viewModel = LoginViewModel()
    }
    
    func configureViews() {
        
    }
    
    func setupBindings() {

    }
}
