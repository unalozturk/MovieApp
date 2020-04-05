//
//  CustomViewController.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

class KeyboardHandlerVC: UIViewController {
    
    private var keyboardHeight: CGFloat = 0.0
    private var keyboardDuration: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationCenterObservers()
    }

}

//MARK: - Notification Center
extension KeyboardHandlerVC {
    
    private func addNotificationCenterObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
           let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                if self.view.frame.origin.y == 0 {
                keyboardHeight = keyboardSize.height
                keyboardDuration = duration
                UIView.transition(with: self.view, duration: keyboardDuration, options: .transitionCrossDissolve, animations: { self.view.frame.size.height -= self.keyboardHeight
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.transition(with: self.view, duration: keyboardDuration, options: .transitionCrossDissolve, animations: { self.view.frame.size.height += self.keyboardHeight
        })
        
    }
    
}
