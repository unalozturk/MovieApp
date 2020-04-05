//
//  ImageLoader.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class PosterImageLoader: UIImageView {
    
    private var imageURL: URL?
    
    private let activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    func loadImageWithUrl(_ url: URL) {
        
        configureUI()
    
        imageURL = url
        
        image = nil
        activityIndicator.startAnimating()
        
        //Take image if it is in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        
        //Image is not in cache
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
    
    private func configureUI() {
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
           activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
           activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
}
