//
//  AlertView.swift
//  PokerPlanning
//
//  Created by Aline Borges on 04/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlertView: UIViewController {
    
    let onConfirm: (() -> Void)
    let alertTitle: String
    @IBOutlet weak var titleLabel: UILabel!
    
    init(title: String, onConfirm: @escaping (() -> Void)) {
        self.onConfirm = onConfirm
        self.alertTitle = title
        super.init(nibName: String(describing: AlertView.self), bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.alertTitle
    }
    
    @IBAction func confirmTap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        self.onConfirm()
    }
}
