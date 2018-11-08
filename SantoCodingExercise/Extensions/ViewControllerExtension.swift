//
//  ViewControllerExtension.swift
//  SantoCodingExercise
//
//  Created by Santosh Jayapal on 04/11/18.
//  Copyright © 2018 com.santosh.project. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
  
  /// Show Progress loader
  ///
  /// - Parameter isStop: Stop progress view
  func showProgress(isStop: Bool) {
    DispatchQueue.main.async { [weak self] in
      guard let weakSelf = self else {return}
      if isStop {
        MBProgressHUD.hide(for: weakSelf.view, animated: true)
      } else {
        MBProgressHUD.showAdded(to: weakSelf.view, animated: true)
      }
    }
  }
  
  
  /// Show Common alert view
  ///
  /// - Parameters:
  ///   - title: Alert title
  ///   - message: Alert Description message
  func showAlert(_ title:String?, message:String?) {
    DispatchQueue.main.async { [weak self] in
      guard let weakSelf = self else {return}
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
      weakSelf.present(alert, animated: true, completion: nil)
    }
  }
}

