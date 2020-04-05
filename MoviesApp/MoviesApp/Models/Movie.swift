//
//  Movie.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var title: String
    var posterPath: String?
    var voteCount: Int
    var desc: String
    var favorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case desc = "overview"
    }
    
    init() {
        self.id = 0
        self.title = ""
        self.voteCount = 0
        self.posterPath = ""
        self.desc = ""
        self.favorite = false
    }
}
