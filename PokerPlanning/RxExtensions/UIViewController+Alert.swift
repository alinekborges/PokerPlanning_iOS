//
//  UIViewController+Alert.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, completion: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: completion))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
