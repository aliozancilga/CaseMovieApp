//
//  UIView.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 14.09.2021.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shouldRasterize = false
    }
}
