//
//  MoviesViewController.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 9.09.2021.
//

import UIKit

enum MovieState {
    case upComing
    case nowPlaying
}

class MoviesViewController: UIViewController {

    // MARK: - Connection Object
    @IBOutlet weak var sliderControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    fileprivate var currentPageIndex = 0
    let indicator = ActivityIndicator(text: Messages().pleaseWait)
    
    // Setup ViewModel
    
    lazy var moviesViewModel: MoviesViewModel = {
        let viewModel = MoviesViewModel()
        return viewModel
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        var control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.bindViewModel()
        self.moviesViewModel.startServices()
        sliderControl.currentPage = currentPageIndex
        self.moviesViewModel.handleServiceFinish()
    }
 
    
    func configureView() {
        
        self.tableView.register(UINib(nibName: UpComingTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: UpComingTableViewCell.reuseIdentifier)
        self.collectionView.register(UINib(nibName: NowPlayingCollectionViewCell.identifier, bundle: nil),forCellWithReuseIdentifier: NowPlayingCollectionViewCell.identifier)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: Any) {
        
        self.moviesViewModel.refreshData { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: [], animated: false)
                self?.refreshControl.endRefreshing()
            }
        }
        self.moviesViewModel.handleServiceFinish()
     }
    
    func movieDetailController(indexPath: IndexPath,with state: MovieState ) {
        guard let movieDetailController = UIStoryboard.main.instantiateViewController(withIdentifier: MovieDetailViewController.storyboardIndentifier) as? MovieDetailViewController else {
                fatalError("Unable to Instantiate Movie Details View Controller")
            }
        if state == .nowPlaying {
          movieDetailController.movieId = self.moviesViewModel.nowPlayingMovies[indexPath.row].id
          movieDetailController.navigationTitle = self.moviesViewModel.nowPlayingMovies[indexPath.row].title
        }else {
            movieDetailController.movieId = self.moviesViewModel.upComingMovies[indexPath.row].id
            movieDetailController.navigationTitle = self.moviesViewModel.upComingMovies[indexPath.row].title

        }
          present(movieDetailController, animated: true, completion: nil)
        
    }
    
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesViewModel.upComingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpComingTableViewCell.reuseIdentifier, for: indexPath) as? UpComingTableViewCell else {
            fatalError("Unable to dequeueReusableCell UpComingTableViewCell")
        }
        if moviesViewModel.upComingMovies.count > 0 {
            cell.dataSource = moviesViewModel.upComingMovies[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.movieDetailController(indexPath: indexPath, with: .upComing)
        }
    }
    
}

extension MoviesViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return moviesViewModel.nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCollectionViewCell.identifier, for: indexPath) as? NowPlayingCollectionViewCell else {
            fatalError("Unable to dequeueReusableCell NowPlayingCollectionViewCell")
        }

        if self.moviesViewModel.nowPlayingMovies.count > 0 {
            cell.dataSource = self.moviesViewModel.nowPlayingMovies[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.movieDetailController(indexPath: indexPath, with: .nowPlaying)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: self.collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
             let scrollPos = scrollView.contentOffset.x / self.collectionView.frame.width
          
            self.sliderControl.currentPage = Int(round(scrollPos))
            currentPageIndex = self.sliderControl.currentPage
    }
}

extension MoviesViewController {
    fileprivate func bindViewModel() {
        self.moviesViewModel.changeHandler = { [weak self ] state in
            guard let self = self else { return }
            switch state {
            case .successNowPlayingMovies:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.sliderControl.numberOfPages = self.moviesViewModel.nowPlayingMovies.count
                } 
            case .successUpComingMovies:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                Alert.showAlert(on: self, with: "Error", message: error.descriptionError)
                break
            case .startLoading:
                self.indicator.show()
                break
            case .finishLoading:
                self.indicator.hide()
                break
            }
        }
    }
}
