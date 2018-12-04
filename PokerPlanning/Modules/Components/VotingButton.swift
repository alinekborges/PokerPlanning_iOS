//
//  VotingButton.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit

class VotingButton: UIButton {
    
    var pressed: Bool = false {
        didSet {
            self.setState(isSelected)
        }
    }
    
    lazy var whiteView: UIView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
        self.addSubview(whiteView)
        whiteView.backgroundColor = .white
        self.whiteView.prepareForConstraints()
        self.whiteView.pinEdgesToSuperview(3)
        self.whiteView.layer.cornerRadius = 14
        self.whiteView.isUserInteractionEnabled = false
        
        self.applyOrangeGradient()
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 43, weight: .bold)
        self.setState(false)
    }
    
    func setState(_ selected: Bool) {
        self.whiteView.isHidden = selected
        let color = selected ? .white : #colorLiteral(red: 0.9995236993, green: 0.4772071242, blue: 0.479349196, alpha: 1)
        self.setTitleColor(color, for: .normal)
    }
    
}
