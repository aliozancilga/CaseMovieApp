//
//  ViewCell.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 12.09.2021.
//

import UIKit

extension UITableViewCell {
    
    // MARK: - Static Properties

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
extension UICollectionViewCell {
    
    // MARK: - Static Properties

    static var identifier: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
