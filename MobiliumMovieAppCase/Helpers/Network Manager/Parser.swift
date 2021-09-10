//
//  Parser.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 9.09.2021.
//

import Foundation

class Parser {
    
    static func parse<T: Decodable>(_ data: Data?) -> T? {
        
        // Validation
        guard let _data = data else {
            return nil
        }
        
        // Parsing
        do {
            let modal = try JSONDecoder().decode(T.self, from: _data)
            return modal
        }catch {
            print("Parsing Error")
            return nil
        }
    }
    
}
