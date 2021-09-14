//
//  DataManager.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 9.09.2021.
//

import Foundation

struct DataManager: MovieAPIProtocol {
    
    // MARK: Life Cycle
    
    private init() {
    }
    
    static let shared = DataManager()
    let network = Network()
    let messages = Messages()
    let keys = GetPostKeys()


}

extension DataManager {
    
    func getUpComingMovies(completion: @escaping (Result<MovieModel, GenericError>) -> ()) {
        
        // Query params
        var queryParams = Parameters()
        queryParams[keys.apiKey] = Domain.apiKey
        
        network.request(path: .getUpComing, method: .get, headers: HTTPHeaders(), pathParams: PathParameters(), queryParams: queryParams, body: Data(), completion: completion)
    }
    
    func getNowPlayingMovies(completion: @escaping (Result<MovieModel, GenericError>) -> ()) {
        
        // Query params
        var queryParams = Parameters()
        queryParams[keys.apiKey] = Domain.apiKey
        
        network.request(path: .getNowPlaying, method: .get, headers: HTTPHeaders(), pathParams: PathParameters(), queryParams: queryParams, body: Data(), completion: completion)
    }
    
    func getMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetail, GenericError>) -> ()) {
        
        // Query params
        var queryParams = Parameters()
        queryParams[keys.apiKey] = Domain.apiKey
        
        // Path params
        var parameter = PathParameters()
        parameter[keys.movieId] = String(movieId)
        
        network.request(path: .getMovie, method: .get, headers: HTTPHeaders(), pathParams: parameter, queryParams: queryParams, body: Data(), completion: completion)
    }
}
