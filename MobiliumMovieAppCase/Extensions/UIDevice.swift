//
//  UIDevice.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 18.09.2021.
//

import UIKit

extension UIDevice {
    
    var hasNotch: Bool {
         if #available(iOS 13, *) {
            let bottom = UIApplication.shared.windows[0].safeAreaInsets.bottom
            return bottom > 0
          } else {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
         }
     }
}
