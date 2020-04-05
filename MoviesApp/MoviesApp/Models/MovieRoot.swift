//
//  MovieRoot.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import Foundation

struct MovieRoot: Codable {
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
    
    init() {
        self.page = 0
        self.totalPages = 0
        self.totalResults = 0
        self.movies = []
    }
}
