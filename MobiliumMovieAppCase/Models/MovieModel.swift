//
//  MovieModel.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 10.09.2021.
//

import Foundation

struct MovieModel: Codable {
    
    var results: [MovieData]
}

struct MovieData: Codable {
    
    var id: String?
    var title: String?
    var orginalTitle: String?
    var overView: String?
    var posterPath: String?
    var vote: Double?
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case vote = "vote_average"
        case posterPath = "poster_path"
        case overView = "over_view"
        case orginalTitle = "orginal_title"
        case releaseDate = "release_date"
    }
}
