//
//  UIViewController.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 10.09.2021.
//

import UIKit

extension UIViewController {
    
    // MARK: - Static Properties
    
    static var storyboardIndentifier: String {
        return String(describing: self)
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
