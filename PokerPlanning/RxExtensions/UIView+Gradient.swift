//
//  UIView+Gradient.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [CGPoint]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = locations?.first ?? CGPoint.zero
        gradient.endPoint = locations?.last ?? CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyOrangeGradient() {
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 1, y: 1)
        self.applyGradient(colours: [#colorLiteral(red: 0.9995236993, green: 0.4772071242, blue: 0.479349196, alpha: 1), #colorLiteral(red: 0.9346098304, green: 0.7254225612, blue: 0.3576000333, alpha: 1)], locations: [start, end])
    }
}
