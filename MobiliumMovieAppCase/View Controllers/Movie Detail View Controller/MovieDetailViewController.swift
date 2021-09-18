//
//  MovieDetailViewController.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 9.09.2021.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {

    // MARK: - Connection Objects
    @IBOutlet weak var navigationViewBar: NavigationBar!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieVote: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
 
    // MARK: - Properties
    var movieId: Int = 0
    var navigationTitle: String?
    let indicator = ActivityIndicator(text: Messages().pleaseWait)

     func webViewController(_ id: String) {
        guard let webViewController = UIStoryboard.main.instantiateViewController(withIdentifier: WebViewController.storyboardIndentifier) as? WebViewController else {
                fatalError("Unable to Instantiate Web View Controller")
            }
           webViewController.imdbId = self.movieDetailViewModel.movie?.imdbId
           present(webViewController, animated: true, completion: nil)
        
    }
    
    // Setup ViewModel
    
    lazy var movieDetailViewModel: MovieDetailViewModel = {
        let viewModel = MovieDetailViewModel()
        return viewModel
    }()
    
    
     // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.indicator.show()
        movieDetailViewModel.getMovieDetail(movieId: movieId)
        self.bindViewModel()
      }
    
    func configureView() {
        if let title = navigationTitle {
            self.navigationViewBar.setTitle(title: title)
        }
        navigationViewBar.backAction = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
            }
        }
 
    }
    
    
    @IBAction func imdbAction(_ sender: Any) {
         if let id =  self.movieDetailViewModel.movie?.imdbId {
            self.webViewController(id)
        }
    }
    
    func UISetup() {
        
        let movie = self.movieDetailViewModel.movie
        if let title = movie?.title {
            self.movieTitle.text =  title + " (" + (movie?.releaseDate?.toDateString(dateFormatter: DateFormatter(format: "yyyy-mm-dd"), outputFormat: "yyyy"))! + ")"
        }

        if let date = movie?.releaseDate {
            self.releaseDate.text = date.toDateString(dateFormatter: DateFormatter(format: "yyyy-mm-dd"), outputFormat: "dd.mm.yyyy")
        }
        self.movieDescription.text = movie?.overview
        if let vote = movie?.voteAverage {
            self.movieVote.text = "\(String(describing: vote))"
        }
        if let imageUrl = self.movieDetailViewModel.movie?.backdropPath {
            self.posterImage.sd_setImage(with: URL(string: (Domain.tmdbImageUrl + imageUrl)), placeholderImage: #imageLiteral(resourceName: "no-image"), options: SDWebImageOptions.scaleDownLargeImages, context: nil)
        }
    }
}

extension MovieDetailViewController {
    fileprivate func bindViewModel() {
        self.movieDetailViewModel.changeHandler = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .success:
                self.indicator.hide()
                DispatchQueue.main.async {
                    self.UISetup()
                 }
             case .failure(let error):
                self.indicator.hide()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                  Alert.showAlert(on: self, with: "Error", message: error.descriptionError)
                }
                break
            }
        }
    }
}

