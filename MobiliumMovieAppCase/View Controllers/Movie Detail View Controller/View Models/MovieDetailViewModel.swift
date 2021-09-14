//
//  MovieDetailViewModel.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 12.09.2021.
//

import Foundation


enum MoviesDetailViewModelState {
    case success
    case failure(GenericError)
}

protocol MovieDetailsProtocol {
    
    var movie: MovieDetail? { get }
    func getMovieDetail(movieId: Int)
    var changeHandler: ((MoviesDetailViewModelState)->())? { get set }
}

class MovieDetailViewModel: MovieDetailsProtocol {
 
    var changeHandler: ((MoviesDetailViewModelState) -> ())?
    
    var movie: MovieDetail?
    
    init() {}
    
    func getMovieDetail(movieId: Int) {
         DataManager.shared.getMovieDetail(movieId: movieId) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.changeState(with: .success)
                self.movie = data
            case .failure(let error):
                self.changeState(with: .failure(error))
            }
        }
    }
    
    private func changeState(with state: MoviesDetailViewModelState) {
        self.changeHandler?(state)
    }
}

