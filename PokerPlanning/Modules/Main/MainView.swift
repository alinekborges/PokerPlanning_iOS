//
//  MainView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 11/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainViewDelegate: class {
    
}

class MainView: UIViewController {
    
    var viewModel: MainViewModel!
    
    weak var delegate: MainViewDelegate?

    init() {
        super.init(nibName: String(describing: MainView.self), bundle: nil)
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

extension MainView {
    
    func setupViewModel() {
        self.viewModel = MainViewModel()
    }
    
    func configureViews() {
        
    }
    
    func setupBindings() {

    }
}
