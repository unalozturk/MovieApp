//
//  CustomBarButton.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

class CustomBarButton: UIButton {
    
    var menuBarItem = UIBarButtonItem()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        menuBarItem = UIBarButtonItem(customView: self)
        NSLayoutConstraint.activate([
            menuBarItem.customView!.widthAnchor.constraint(equalToConstant: 24),
            menuBarItem.customView!.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    
    
}
