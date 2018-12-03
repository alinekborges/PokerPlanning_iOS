//
//  LoadingView.swift
//  mood-reading-machines
//
//  Created by Aline Borges on 29/11/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

internal final class DefaultLoadingView: UIVisualEffectView {
    
    private var activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(style: .gray)
    }()
    
    init() {
        super.init(effect: nil)
        self.setupViews()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        self.addToTopController()
        UIView.animate(withDuration: 0.2) {
            self.effect = UIBlurEffect(style: .light)
        }
        self.activityIndicator.startAnimating()
    }
    
    func stop() {
        UIView.animate(withDuration: 0.2, animations: {
            self.activityIndicator.stopAnimating()
            self.effect = nil
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.contentView.addSubview(activityIndicator)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
        self.activityIndicator.prepareForConstraints()
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
    }
    
    private func addToTopController() {
        guard let topController = UIApplication.shared.keyWindow?.rootViewController?.view else {
            return
        }
        topController.addSubview(self)
        self.prepareForConstraints()
        self.pinEdgesToSuperview()
        topController.layoutIfNeeded()
    }
}

extension Reactive where Base: DefaultLoadingView {
    
    var isLoading: Binder<Bool> {
        return Binder(self.base) { view, isLoading in
            if isLoading {
                view.start()
            } else {
                view.stop()
            }
        }
    }
    
}
