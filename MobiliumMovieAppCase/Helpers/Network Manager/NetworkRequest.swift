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


struct Network {
    
    func generateRequest(baseURL: String, path: APIEndpoint, method: HTTPMethod, headers: HTTPHeaders, pathParams: PathParameters, queryParams: Parameters, body: Data) -> URLRequest? {
        
        guard let url = baseURL.url else {
            return nil
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        urlComponents.path.append(bindPathParamsAndGeneratePath(from: pathParams, path: path))
        urlComponents.queryItems = generateQueryParams(queryParams)
        
        // Prepare final URL
        guard let completeURL = urlComponents.url else {
            return nil
        }
        
        // Prepare Request
        var request = URLRequest(url: completeURL)
        request.httpMethod = method.name
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
    
    func bindPathParamsAndGeneratePath(from params: PathParameters, path: APIEndpoint) -> String {
        if params.count > 0 {
            
            var path = path.string
            for (key, value) in params {
                path = path.replacingOccurrences(of: "{\(key)}", with: value)
            }
            return path
        }else {
            
            return path.string
        }
    }
}


extension Network {
    
    
    fileprivate func buildRequest(path: APIEndpoint, method: HTTPMethod, headers: HTTPHeaders, pathParams: PathParameters, queryParams: Parameters, body: Data) -> URLRequest? {
        
        let base = Domain.baseUrl
        return generateRequest(baseURL: base, path: path, method: method, headers: generateHeaders(headers), pathParams: pathParams, queryParams: queryParams, body: body)
            
    }
    
    fileprivate func generateHeaders(_ header: HTTPHeaders) -> HTTPHeaders {
        
        var updatedHeaders = header
        updatedHeaders["Content-Type"] = "application/json"
        return updatedHeaders
    }
    
    fileprivate func generateQueryParams(_ params: Parameters) -> [URLQueryItem]? {
        
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
    
}


extension Network {
    
    func request(path: APIEndpoint, method: HTTPMethod, headers: HTTPHeaders, pathParams: PathParameters, queryParams: Parameters, body: Data, completion: @escaping (_ networkStatus: Bool, _ responseStatus: Bool, _ data: Data?) -> ()) {
        // Connection Validation
        let reachability = try! Reachability()

        reachability.whenUnreachable = { _ in
            
             return completion(false, false, nil)
        }
        
        // Prepare request
        let session = URLSession.shared
        guard let request = buildRequest(path: path,  method: method, headers: headers, pathParams: pathParams, queryParams: queryParams, body: body) else {
            
            return completion(true, false, nil)
        }
     
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // Validation
            if error != nil {
                
                completion(true, false, nil)
            }
      
            // Notify parent with response data
            completion(true, true, data)
        }
        task.resume()
    }
}
