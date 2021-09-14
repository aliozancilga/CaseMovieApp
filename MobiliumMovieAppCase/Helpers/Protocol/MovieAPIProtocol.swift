//
//  MovieAPIProtocol.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 11.09.2021.
//

import Foundation

protocol MovieAPIProtocol {
    
    func getUpComingMovies(completion: @escaping (Result<MovieModel, GenericError>)-> ())
    func getNowPlayingMovies(completion: @escaping (Result<MovieModel, GenericError>)-> ())
    func getMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetail, GenericError>)-> ())
}
