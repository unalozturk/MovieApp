//
//  MoviesServices.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import Foundation


struct MoviesServices {
    static let sharedInstance = MoviesServices()
    let provider = ServiceProvider<MoviesApi>()
    
    func popularMovies(pageId: Int, completion: @escaping (MovieRoot?,Error?)->()) {
        provider.load(service: .popularMovies(pageId: pageId)) { result in
            switch result {
            case .success(let data):
                do {
                    let movieRoot = try JSONDecoder().decode(MovieRoot.self, from: data)
                    completion(movieRoot,nil)
                } catch let error {
                    completion(nil,error)
                }
            case .failure(let error):
                completion(nil, error)
            case .empty:
                fatalError("No data")
            }
        }
    }
    
    func movieDetail(movieId: Int, completion: @escaping (Movie?,Error?)->()) {
        provider.load(service: .movieDetail(movieId: movieId)) { result in
            switch result {
            case .success(let data):
                let movie = try? JSONDecoder().decode(Movie.self, from: data)
                completion(movie,nil)
            case .failure(let error):
                completion(nil, error)
            case .empty:
                fatalError("No data")
            }
        }
    }
}

