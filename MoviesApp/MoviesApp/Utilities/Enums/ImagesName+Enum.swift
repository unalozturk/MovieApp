//
//  Images.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

//MARK: - Navigation Bar
enum FavoriteBarButton {
    case notFavorited
    case favorited
    
    var image: UIImage {
        switch self {
        case .notFavorited:
            return UIImage(named: "star")!
        case .favorited:
            return UIImage(named: "fillstar")!
        }
    }
}

enum StyleBarButton {
    case grid
    case list
    
    var image: UIImage {
        switch self {
        case .grid:
            return UIImage(named: "list")!
        case .list:
            return UIImage(named: "grid")!
        }
    }
}
