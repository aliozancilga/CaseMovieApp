//
//  NowPlayingCollectionViewCell.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 10.09.2021.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    

    // MARK - Connection Objects
    
    @IBOutlet weak private var posterImage: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    
    var dataSource: Movie? {
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      }
    
    func setData() {
      
        self.posterImage.downloaded(from: Domain.tmdbImageUrl + (self.dataSource?.backdropPath)!, contentMode: .scaleAspectFill)
        DispatchQueue.main.async {
            
            self.titleLabel.text =  self.dataSource?.title
             self.descriptionLabel.text = self.dataSource?.overview
        }
    }
}
