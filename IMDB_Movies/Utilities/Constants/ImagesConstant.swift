//
//  ImagesConstant.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit

struct Images {
  static let circularLoader = getImageFrom(name: "circularLoader")
  static let placeholder = getImageFrom(name: "placeholder")
  
  static func getImageFrom(name: String) -> UIImage {
    return UIImage(named: name)!
  }
}


