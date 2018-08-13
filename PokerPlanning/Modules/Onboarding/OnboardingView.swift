//
//  OnboardingView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 09/08/2018.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingView: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: OnboardingViewModel!
    
    var delegate: AppActionable?

    init() {
        super.init(nibName: String(describing: OnboardingView.self), bundle: nil)
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

extension OnboardingView {
    
    func setupViewModel() {
        self.viewModel = OnboardingViewModel()
    }
    
    func configureViews() {
        
    }
    
    func setupBindings() {
        self.loginButton.rx.tap.bind {
            self.delegate?.handle(.finishOnboarding)
        }.disposed(by: rx.disposeBag)
    }
}
