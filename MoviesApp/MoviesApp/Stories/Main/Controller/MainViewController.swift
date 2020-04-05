//
//  MainViewController.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import UIKit

class MainViewController: KeyboardHandlerVC {

    private var collectionView: UICollectionView!
    private var collectionViewFlowLayout: UICollectionViewFlowLayout!
    private var collectionViewType: StyleBarButton = .grid
    private var reloadDuration = 0.35
    private var pageId = 1
    private var isWaiting = false
    
    private let numberOfItemPerRow: CGFloat = 2
    private let numberOfItemPerColumn: CGFloat = 3
    private let lineSpacing: CGFloat = 5
    private let interItemSpacing: CGFloat = 5
    
    private var searchBar = UISearchBar()
    private var isSearching = false
    private var menuBtn = CustomBarButton()
    
    
    private var movieRoot = MovieRoot()
    private var filteredMovieRoot = MovieRoot()
    private var favoriteIds = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationCenterObservers()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureRightButtonItem()
        configureSearchBar()
        configureCollectionView()
        fetchPopularMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionViewFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteIds = DataPersistence.fetchFavorites()
    }
    
}

//MARK: - Notification Center
extension MainViewController {

    private func addNotificationCenterObservers() {
        //To handle screen rotation, iOS 9 or later we do not need to deallocated it.
        NotificationCenter.default.addObserver(self, selector: #selector(measureCellSize), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
}

//MARK: - SearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Enter To Search Movie"
        navigationItem.titleView = searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        navigationItem.rightBarButtonItem = menuBtn.menuBarItem
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovieRoot = movieRoot
        if !searchText.isEmpty{
            isSearching = true
            filteredMovieRoot.movies = movieRoot.movies.filter({ $0.title.range(of: searchText, options: [.caseInsensitive, .anchored]) != nil })
        } else {
            isSearching = false
        }
        
        UIView.transition(with: collectionView, duration: reloadDuration, options: .transitionCrossDissolve, animations: { self.collectionView.reloadData()
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovieRoot = movieRoot
        UIView.transition(with: collectionView, duration: reloadDuration, options: .transitionCrossDissolve, animations: { self.collectionView.reloadData()
        })
    }
}

//MARK: - NavigationBar Item
extension MainViewController  {
    
    private func configureRightButtonItem() {
           menuBtn.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
           menuBtn.setImage(collectionViewType.image, for: .normal)
           navigationItem.rightBarButtonItem = menuBtn.menuBarItem
    }
    
    @objc func toggleView() {
        switch collectionViewType {
        case .grid:
            collectionViewType = .list
        case .list:
            collectionViewType = .grid
        }
        
        menuBtn.setImage(collectionViewType.image, for: .normal)
        measureCellSize()
    }
    
}

//MARK: - CollectionView
extension MainViewController {
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: -5),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor,constant: -5),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor,constant: 5),
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        self.collectionView = collectionView
        
    }
}

//MARK: - CollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovieRoot.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        //Find movie and if it is favorite movie, change that movie as favorite
        var movie = filteredMovieRoot.movies[indexPath.row]
        movie.favorite = favoriteIds.contains(movie.id)
        filteredMovieRoot.movies[indexPath.row] = movie
        
        cell.configureWithMovie(movie: movie)
        return cell
    }
}

//MARK: - CollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let detailVC = MovieDetailViewController()
        detailVC.movie = filteredMovieRoot.movies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = movieRoot.movies.count - 1
        if indexPath.row == lastItem, !isWaiting, pageId < movieRoot.totalPages, !isSearching {
            isWaiting = true
            fetchPopularMovies()
        }
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionViewFlowLayout() {
        if collectionViewFlowLayout == nil {
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
             measureCellSize()
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc private func measureCellSize() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch collectionViewType {
        case .grid:
            width = (collectionView.frame.width - (numberOfItemPerRow - 1) * interItemSpacing) / numberOfItemPerRow
            height = (collectionView.frame.height - (numberOfItemPerColumn - 1) * lineSpacing) / numberOfItemPerColumn
        case .list:
            width = collectionView.frame.width
            height = collectionView.frame.height / (numberOfItemPerRow * numberOfItemPerColumn) // To show same count items
        }
        
        UIView.transition(with: view, duration: reloadDuration, options: .transitionCrossDissolve, animations: { self.collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
        })
       
    }
    
}

//MARK: - Services
extension MainViewController {
    
    private func fetchPopularMovies() {
        MoviesServices.sharedInstance.popularMovies(pageId: pageId) { [weak self] result, error in
            
            guard let `self` = self else { return }
            if error == nil {
                guard let movieRoot = result else { return }
                if self.pageId == 1 {
                    self.movieRoot = movieRoot
                } else  {
                    self.movieRoot.movies.append(contentsOf: movieRoot.movies)
                }
                
                self.filteredMovieRoot = self.movieRoot
                self.pageId += 1 
                self.isWaiting = false
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                self.showAlertView(title: "Error", message: error!.localizedDescription)
            }
        }
    }
}
