//
//  MoviesApi.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import Foundation

enum MoviesApi {
    case popularMovies(pageId: Int)
    case movieDetail(movieId: Int)
}

extension MoviesApi: Service {
    
    var baseURL: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .popularMovies(_):
            return "/3/movie/popular/"
        case .movieDetail(let movieId):
            return "/3/movie/\(movieId)"
        }
    }
    
    var parameters: [String : Any]? {
        //default params
        var params: [String: Any] = ["api_key": "fd2b04342048fa2d5f728561866ad52a"]
        
        switch self {
        case .popularMovies(let pageId):
            params["page"] = String(pageId)
        case .movieDetail(_):
            break
        }
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
