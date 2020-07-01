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
  var date: String
  var genres: String
  var overview: String
  
  init(id: Int, name: String, image: String) {
    self.id = id
    self.name = name
    self.image = image
    
    self.date = ""
    self.genres = ""
    self.overview = ""
  }
  
  init(id: Int, name: String, image: String, date: String, genres: String, overview: String) {
    self.id = id
    self.name = name
    self.image = image
    self.date = date
    self.genres = genres
    self.overview = overview
  }
}
