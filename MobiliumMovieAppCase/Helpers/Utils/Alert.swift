//
//  Alert.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 14.09.2021.
//

import Foundation
import UIKit


struct Alert {
 
  static func showAlert(on vc:UIViewController, with title:String, message:String) {
     
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
  
    alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: nil))
                        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
     }
  }
}
