//
//  UITableView.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit

extension UITableView {
  
  /// Method to register UITableViewCell. Only use this method when the class and xib names are same else it might result in crash.
  ///
  /// - Parameter nib: Name of the class or xib.
  func registerCell(with xib: String) {
    register(UINib(nibName: xib, bundle: nil), forCellReuseIdentifier: xib)
  }
}
