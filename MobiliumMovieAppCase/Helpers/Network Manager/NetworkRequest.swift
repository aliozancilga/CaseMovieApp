//
//  NetworkRequest.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 9.09.2021.
//

import Foundation


 // MARK: - Type Alias

public typealias Parameters = [String: Any]
public typealias PathParameters = [String: String]
public typealias HTTPHeaders = [String: String]


public enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var name: String {
        return self.rawValue
    }
}

public enum GenericError: Error {
    
    case genericError
    case noConnection
    
    var descriptionError: String {
        switch self {
         case .genericError:
            return "Something Wrong. Please try again later."
        case .noConnection:
            return "No internet connection"
        }
    }
}

public enum NetworkLayerError: Error {
    case invalidResponse
    case parserError
    case noDataFound
    case invalidEndpoint
    case apiError
    case noConnection
    
    var descriptionError: String {
        switch self {
        case .apiError:
            return "apiError"
        case .invalidResponse:
            return "Bad Server Response"
        case .parserError:
            return "parserError"
        case .noDataFound:
            return "noDataFound"
        case .invalidEndpoint:
            return "Base URL building failed!"
        case .noConnection:
            return "No internet connection"
        }
    }
    
}

 struct Network {
    
    func request <T: Decodable>(path: APIEndpoint, method: HTTPMethod, headers: HTTPHeaders, pathParams: PathParameters, queryParams: Parameters, body: Data, completion: @escaping (Result<T, GenericError>) -> ()) {
        
        let baseURL = Domain.baseUrl

        // Connection Validation
        let reachability = try! Reachability()

        reachability.whenUnreachable = { _ in
            
            print("Error:\(NetworkLayerError.noConnection.descriptionError)")
            
            completion(.failure(.noConnection))
             return
        }
        
        // Prepare request
        let session = URLSession.shared
 
        guard let url = baseURL.url else {
            return
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Error:\(NetworkLayerError.invalidEndpoint.descriptionError)")
            completion(.failure(.genericError))
            return
        }
        
        urlComponents.path.append(bindPathParamsAndGeneratePath(from: pathParams, path: path))
        urlComponents.queryItems = generateQueryParams(queryParams)
        
        // Prepare final URL
        guard let completeURL = urlComponents.url else {
            print("Error:\(NetworkLayerError.invalidEndpoint.descriptionError)")
            completion(.failure(.genericError))
            return
        }
        
        // Prepare Request
        var request = URLRequest(url: completeURL)
        request.httpMethod = method.name
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
        
            guard error == nil else{
                
                print("Error:\(NetworkLayerError.apiError.descriptionError)")
                completion(.failure(.genericError))

                return
            }
            
            let successRange = 200..<300
            // Validation
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print("Error:\(NetworkLayerError.invalidResponse.descriptionError)")
                completion(.failure(.genericError))
                return
            }
            
            guard let data = data else {
                print("Error:\(NetworkLayerError.invalidResponse.descriptionError)")
                completion(.failure(.genericError))
                return
            }
            
            guard let responseData: T = Parser.parse(data) else {
                print("Error:\(NetworkLayerError.parserError.descriptionError)")

                completion(.failure(.genericError))
                return
            }

            completion(.success(responseData))
        }
        task.resume()
    }
}

    

fileprivate extension Network {
    
    
    func generateHeaders(_ header: HTTPHeaders) -> HTTPHeaders {
        
        var updatedHeaders = header
        updatedHeaders["Content-Type"] = "application/json"
        return updatedHeaders
    }
    
    func generateQueryParams(_ params: Parameters) -> [URLQueryItem]? {
        
        // Preapre Query URL
        if params.count >= 0 {
            
            var queryItems: [URLQueryItem] = []
            params.forEach { (key, value) in
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            
            if queryItems.count > 0 {
               return queryItems
            }
            else {
                return nil
            }
            
        }
        return nil
    }
    
    func bindPathParamsAndGeneratePath(from params: PathParameters, path: APIEndpoint) -> String {
        if params.count > 0 {
            
            var path = path.name
            for (key, value) in params {
                path = path.replacingOccurrences(of: "{\(key)}", with: value)
            }
            return path
        }else {
            
            return path.name
        }
    }
    
}
