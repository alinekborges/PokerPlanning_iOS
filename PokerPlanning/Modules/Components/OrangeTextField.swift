//
//  OrangeTextField.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit

class OrangeTextField: UITextField {
    
    lazy var underline: UIView = UIView()
    
    override func awakeFromNib() {
        self.borderStyle = .none
        self.font = UIFont.systemFont(ofSize: 22.0, weight: .light)
        self.autocorrectionType = .no
        self.tintColor = #colorLiteral(red: 0.9995236993, green: 0.4772071242, blue: 0.479349196, alpha: 1)
        
        self.addSubview(underline)
        self.underline.prepareForConstraints()
        self.underline.pinBottom()
        self.underline.pinLeft()
        self.underline.pinRight()
        self.underline.constraintHeight(1)

        self.layoutIfNeeded()
        
        self.underline.applyOrangeGradient()
    }
    
}
