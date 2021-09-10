//
//  DataManager.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 9.09.2021.
//

import Foundation

struct DataManager {
    
    // MARK: Life Cycle
    
    private init() {
    }
    
    static let shared = DataManager()
    let network = Network()
    let messages = Messages()
    let keys = GetPostKeys()


}

extension DataManager {
    
    func getUpComingMovies(completion: @escaping (_ status: Bool, _ statusMessage: String, _ data: String?) -> ()) {
        
        // Failure closure
        func failure(_ message: String) {
            completion(false, message, nil)
        }
        
        // Prepare params
        var queryParams = Parameters()
        queryParams[keys.apiKey] = Domain.apiKey
        
        // Send Request
        network.request(path: APIEndpoint.getUpComing, method: .get, headers: HTTPHeaders(), pathParams: PathParameters(), queryParams: queryParams, body: Data()) { networkStatus, responseStatus, data in
                
        }
        
    }
    
    func getNowPlayingMovies(completion: @escaping (_ status: Bool, _ statusMessage: String, _ data: String?) -> ()) {
        
        // Failure closure
        func failure(_ message: String) {
            completion(false, message, nil)
        }
        
        
        // Prepare params
        var queryParams = Parameters()
        queryParams[keys.apiKey] = Domain.apiKey
        
        // Send Request
        network.request(path: APIEndpoint.getNowPlaying, method: .get, headers: HTTPHeaders(), pathParams: PathParameters(), queryParams: Parameters(), body: Data()) { networkStatus, responseStatus, data in
                 
        }
    }
    
    
    func getMovieDetail(movieId: String, completion: @escaping (_ status: Bool, _ statusMessage: String, _ data: String?) -> ()) {
        
        // Failure closure
        func failure(_ message: String) {
            completion(false, message, nil)
        }
        
        var parameter = PathParameters()
        parameter[keys.movieId] = movieId

        
        // Prepare params
        var queryParams = Parameters()
        queryParams[keys.apiKey] = Domain.apiKey
        
        
        // Send Request
        network.request(path: APIEndpoint.getMovie, method: .get, headers: HTTPHeaders(), pathParams: parameter, queryParams: Parameters(), body: Data()) { networkStatus, responseStatus, data in
        
        }
    }

}
