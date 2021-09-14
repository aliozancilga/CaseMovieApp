//
//  MovieModel.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 10.09.2021.
//

import Foundation

struct MovieModel: Decodable {
    
    var page: Int?
    var results: [Movie]?
}

struct Movie: Decodable {
    
    var id: Int
    var title: String?
    var backdropPath: String?
    var overview: String?
    var posterPath: String?
    var voteAverage: Double?
    var releaseDate: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }
}

struct MovieDetail: Decodable {
    
    var id: Int
    var title: String?
    var overview: String?
    var backdropPath: String?
    var posterPath: String?
    var imdbId: String?
    var voteAverage: Double?
    var releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case imdbId = "imdb_id"
        case releaseDate = "release_date"

    }

}
