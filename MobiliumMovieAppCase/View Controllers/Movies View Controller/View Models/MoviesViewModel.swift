//
//  MoviesViewModel.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 12.09.2021.
//

import Foundation


enum MoviesViewModelState {
    case successUpComingMovies
    case successNowPlayingMovies
    case failure(GenericError)
    case startLoading
    case finishLoading
}

protocol MoviesViewModelProtocol {
    var upComingMovies: [Movie] { get }
    var nowPlayingMovies: [Movie] { get }
    func refreshData(completion: ()->())
    func startServices()
    var changeHandler: ((MoviesViewModelState)->())? { get set }
}

class MoviesViewModel: MoviesViewModelProtocol {
 
    var upComingMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    
    let dispatchGroup = DispatchGroup()
    var changeHandler: ((MoviesViewModelState) -> ())?
    
    init() {}
    
    func refreshData(completion: ()->()) {
        upComingMovies.removeAll()
        nowPlayingMovies.removeAll()
        startServices()
        completion()
    }
    
    func startServices() {
        changeState(with: .startLoading)
        getUpComingMovies()
        getNowPlayingMovies()
    }
    
    private func getUpComingMovies() {
        self.dispatchGroup.enter()
        DataManager.shared.getUpComingMovies { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
              case .success(let data):
                self.changeState(with: .successUpComingMovies)
                self.upComingMovies = data.results!
                self.dispatchGroup.leave()
               case .failure(let error):
                self.changeState(with: .failure(error))
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func getNowPlayingMovies() {
        self.dispatchGroup.enter()
        DataManager.shared.getNowPlayingMovies { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.changeState(with: .successNowPlayingMovies)
                self.nowPlayingMovies = data.results!
                 self.dispatchGroup.leave()

            case .failure(let error):
                self.changeState(with: .failure(error))
                self.dispatchGroup.leave()

            }
        }
    }
    
    func handleServiceFinish() {
        dispatchGroup.notify(queue: .main) {
            self.changeState(with: .finishLoading)
        }
    }
    
    private func changeState(with state: MoviesViewModelState) {
        self.changeHandler?(state)
    }
}
