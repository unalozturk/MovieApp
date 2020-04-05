//
//  UIColor+Extension.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1)
    }
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
}
