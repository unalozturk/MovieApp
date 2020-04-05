//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private var movieDetailView = MovieDetailView()
    private var menuBtn = CustomBarButton()
    private var rightIconImage: FavoriteBarButton = .notFavorited
    
    var movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetail(movieId: movie.id)
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(movieDetailView)
        NSLayoutConstraint.activate([
            movieDetailView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            movieDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieDetailView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - NavigationBar
extension MovieDetailViewController {
    
    private func configureNavigationBar() {
        title = "Content Details"
        configureRightButtonItem()
    }
    
    private func configureRightButtonItem() {
        menuBtn.addTarget(self, action: #selector(favoriteToggle), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = menuBtn.menuBarItem
    }
    
    private func configureMovieStatus() {
        if movie.favorite {
            DataPersistence.favoriteItem(moveId: movie.id)
            rightIconImage = .favorited
        } else {
            DataPersistence.removeFavoriteItem(moveId: movie.id)
            rightIconImage = .notFavorited
        }
        menuBtn.setImage(rightIconImage.image, for: .normal)
    }
    
    @objc func favoriteToggle()  {
        movie.favorite.toggle()
        configureMovieStatus()
    }
}

//MARK: - Services
extension MovieDetailViewController {
    
    private func fetchMovieDetail(movieId: Int) {
        MoviesServices.sharedInstance.movieDetail(movieId: movieId) { [weak self] result, error in
            guard let `self` = self else { return }
            if error == nil {
                guard let movie = result else { return }
                self.configureMovieStatus()
                self.movieDetailView.titleLabel.text = movie.title
                self.movieDetailView.descriptionLabel.text = movie.desc
                
                //Poster Image
                guard
                    let posterPath = movie.posterPath,
                    let url = self.movieDetailView.posterImage.tmdbImageUrl(width: self.view.frame.size.width, path: posterPath)
                else { return }
                
                self.movieDetailView.posterImage.loadImageWithUrl(url)
                
            } else {
                self.showAlertView(title: "Error", message: error!.localizedDescription)
            }
        }
    }
}
