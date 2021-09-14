//
//  UpComingTableViewCell.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 10.09.2021.
//

import UIKit

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
            self.posterImage.downloaded(from: Domain.tmdbImageUrl + imageUrl, contentMode: .scaleAspectFill)
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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
