//
//  ActivityIndicatorTableViewCell.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit

class ActivityIndicatorTableViewCell: UITableViewCell {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  func startAnimating() {
    activityIndicator.startAnimating()
  }
  
}

class ActivityIndicatorTableModel: RxAnimatableTableCellModel {
  
  override init() {
    super.init()
    super.id = ""
  }
  
}
