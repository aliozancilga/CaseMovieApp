//
//  RootViewController.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 9.09.2021.
//

import UIKit

final class RootViewController: UIViewController {

   // - MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager
            .shared.getUpComingMovies { _, _, _ in
                
            }
        
    }
    
    // - MARK: - Properties
    
    var viewModel: RootViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
      
            // Setup View Model
           setupViewModel(with: viewModel)
        }
    }
    
     
    
    func setupViewModel(with viewModel: RootViewModel) {
        
    }
    

}
