//
//  NavigationBar.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 12.09.2021.
//

import UIKit


class NavigationBar: UIView {
    
    // MARK: Connection Objects
    @IBOutlet weak var titleLabel: UILabel!
 
    var backAction: (() -> ())?
    
    // Declaration
    var contentView: UIView!
    var nibName: String {
        return String(describing: type(of: self))
    }
 
    func setTitle(title: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = title

        }
    }
    
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    
    // MARK: Arrange View
    func loadViewFromNib() {
        
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }
}

extension NavigationBar {
    
    @IBAction func backAction(_ sender: UIButton) {
         backAction?()
    }
}
