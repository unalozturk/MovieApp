//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "movieCell"
    
    var posterImage: PosterImageLoader = {
        var imageView = PosterImageLoader()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var titleLabel: UILabel =  {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor =  .white
        label.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        return label
    }()
    
    var starImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = FavoriteBarButton.favorited.image
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    private func resetCell() {
        self.titleLabel.text = ""
        self.starImage.isHidden = true
        self.posterImage.image = nil
    }
    
    private func configureUI() {
        backgroundColor = .gray
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        addSubview(posterImage)
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: topAnchor),
            posterImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            posterImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([  
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        addSubview(starImage)
        NSLayoutConstraint.activate([
            starImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            starImage.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            starImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/5),
            starImage.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1/5)
        ])
        
    }
    
    func configureWithMovie(movie: Movie) {
        titleLabel.text = movie.title
        movie.favorite ? (starImage.isHidden = false) : (starImage.isHidden = true)
        
        //To get poster image
        guard
            let posterPath = movie.posterPath,
            let url = posterImage.tmdbImageUrl(width: frame.size.width, path: posterPath)
        else {
            return
        }
        posterImage.loadImageWithUrl(url)
    }
}
