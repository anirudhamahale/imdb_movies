//
//  MovieRealmModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class MovieRealmModel: BaseRealmModel {
  
  @objc dynamic var id = 0
  @objc dynamic var name = ""
  @objc dynamic var image = ""
  @objc dynamic var date = ""
  @objc dynamic var genres = ""
  @objc dynamic var overview = ""
  
  func setAllProperties(_ movie: MovieModel) {
    self.name = movie.name
    self.image = movie.image
    self.date = movie.date
    self.genres = movie.genres
    self.overview = movie.overview
  }
}
