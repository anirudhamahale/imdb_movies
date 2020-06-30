//
//  MovieJsonMapper.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieJSONMapper {
  static func getMoviesListFrom(from rawObject: Any) -> [MovieModel] {
    let json = JSON(rawObject)
    guard let result = json["results"].array else { return [] }
    let movies = result.compactMap { (item) -> MovieModel? in
      guard let id = item["id"].int else { return nil }
      guard let name = item["title"].string else { return nil }
      guard let image = item["poster_path"].string else { return nil }
      return MovieModel(id: id, name: name, image: image)
    }
    return movies
  }
}
