//
//  OrangeButton.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import UIKit

class OrangeButton: UIButton {
    
    override func awakeFromNib() {
        self.backgroundColor = .clear
        self.applyOrangeGradient()
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .light)
    }
}
