//
//  ListTableViewCell.swift
//  SantoCodingExercise
//
//  Created by Santosh Jayapal on 04/11/18.
//  Copyright © 2018 com.santosh.project. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var cellImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  static let identifier = "ListCell"
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }

}
