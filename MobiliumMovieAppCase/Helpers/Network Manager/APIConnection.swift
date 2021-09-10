//
//  APIConnection.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 9.09.2021.
//

import Foundation

struct Domain {
    static let baseUrl: String = "https://api.themoviedb.org/3"
    static let apiKey: String = "ec2a6b106a323e0d4679e2c1fffad8c5"
}

// - MARK: Enpoint URL's

enum APIEndpoint: String {
    
    case getNowPlaying = "/movie/now_playing"
    case getUpComing = "/movie/upcoming"
    case getMovie = "/movie/{movie_id}"
    
    var string: String {
        return self.rawValue
    }
        
}

// Support Keys in GET, POST
struct GetPostKeys {
    
    var apiKey = "api_key"
    var movieId = "movie_id"
}
