//
//  MovieModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation

class MovieModel {
  var id: Int
  var name: String
  var image: String
  
  init(id: Int, name: String, image: String) {
    self.id = id
    self.name = name
    self.image = image
  }
}
