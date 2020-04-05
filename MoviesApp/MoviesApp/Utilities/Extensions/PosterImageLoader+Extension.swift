//
//  ImageLoader+Extension.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

extension PosterImageLoader {
    
    func tmdbImageUrl(width: CGFloat, path: String) -> URL? {
        let imageWidth = Int(width.rounded(to: 100)) //URL returns image for specific sizes, so that we rounded it
        return URL(string:"https://image.tmdb.org/t/p/w\(imageWidth)\(String(describing: path))")
    }
    
}
