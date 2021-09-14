//
//  UpComingTableViewCell.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 10.09.2021.
//

import UIKit
import SDWebImage

class UpComingTableViewCell: UITableViewCell {

    // MARK: - Connection Objects

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var posterImage: UIImageView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    

    var dataSource: Movie? {
        didSet {
            setData()
        }
    }
    

    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setData() {
        if let dateString = self.dataSource?.releaseDate {
            
          self.dateLabel.text = dateString
        }
      
        if let imageUrl = self.dataSource?.backdropPath {
            self.posterImage.sd_setImage(with: URL(string: (Domain.tmdbImageUrl + imageUrl)), placeholderImage: #imageLiteral(resourceName: "no-image"), options: SDWebImageOptions.scaleDownLargeImages, context: nil)
        }
        DispatchQueue.main.async {
            self.titleLabel.text = self.dataSource?.title
            self.descriptionLabel.text = self.dataSource?.overview
        }
    }
}

extension UpComingTableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
