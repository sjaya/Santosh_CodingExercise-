//
//  CustomTableViewCell.swift
//  SantoCodingExercise
//
//  Created by Santosh Jayapal on 18/11/18.
//  Copyright © 2018 com.santosh.project. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
  
  static let identifier = "CustomCell"
  
  weak var titleLabel: UILabel!
  weak var cellView : UIView!
  weak var cellImageView: UIImageView!
  weak var descriptionLabel: UILabel!
  
  func createCell() { //To create required sub views
    //Create a base view
    if cellView == nil {
      let cellView = UIView(frame: self.bounds)
      cellView.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview(cellView)
      self.cellView = cellView
      
      //Ceate the Title Label
      let titleLabel = UILabel(frame:CGRect(x: 0, y: 10, width: 300, height: 30))
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.textAlignment = .center
      titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
      cellView.addSubview(titleLabel)
      self.titleLabel = titleLabel
      
      //Ceate the Image View
      let imageView = UIImageView(frame:CGRect(x: 0, y: 10, width: 100, height: 150))
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.contentMode = .scaleAspectFit
      cellView.addSubview(imageView)
      cellImageView = imageView
      
      //Ceate the Description Label
      let descLabel = UILabel(frame:CGRect(x: 0, y: 10, width: 300, height: 30))
      descLabel.translatesAutoresizingMaskIntoConstraints = false
      descLabel.textAlignment = .center
      descLabel.numberOfLines = 0
      descLabel.font = UIFont.systemFont(ofSize: 18)
      cellView.addSubview(descLabel)
      self.descriptionLabel = descLabel
      
      allignViews()
    }
  }
  
  
  //Set Autolayout Constraints
  func allignViews() {
    var allConstraints: [NSLayoutConstraint] = []
    
    let views: [String: Any] = [
      "cellView": cellView,
      "titleLabel": titleLabel,
      "cellImageView": cellImageView,
      "descriptionLabel": descriptionLabel ]
    
    //Create constraints for cell base view
    let cellHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[cellView]|", options: .alignAllLeading, metrics: nil, views: views)
    allConstraints += cellHorizontalConstraints
    
    let cellVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[cellView]|", options: .alignAllLeft, metrics: nil, views: views)
    allConstraints += cellVerticalConstraints
    
    //Create Horizontal constraints for sub views
    let titleLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[titleLabel]-10-|", options: .alignAllLeading, metrics: nil, views: views)
    allConstraints += titleLabelHorizontalConstraints
    
    let imageHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cellImageView]-10-|", options: .alignAllCenterX, metrics: nil, views: views)
    allConstraints += imageHorizontalConstraints
    
    let descLabelHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[descriptionLabel]-10-|", options: .alignAllCenterX, metrics: nil, views: views)
    allConstraints += descLabelHorizontalConstraints
    
    //Create verticle constraints for sub views
    let verticleConstraintsAll = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel]-10-[cellImageView]-10-[descriptionLabel]-10-|", options: .alignAllLeft, metrics: nil, views: views)
    allConstraints += verticleConstraintsAll
    
    NSLayoutConstraint.activate(allConstraints)
  }
  
}

