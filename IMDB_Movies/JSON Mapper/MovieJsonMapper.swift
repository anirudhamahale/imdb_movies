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
      guard let title = item["title"].string else { return nil }
      guard let image = item["poster_path"].string else { return nil }
      guard let date = item["release_date"].string else { return nil }
      guard let overview = item["overview"].string else { return nil }
      return MovieModel(id: id, name: title, image: image, date: date, genres: "", overview: overview)
    }
    return movies
  }
  
  static func getMovieDetailFrom(from rawObject: Any) -> MovieModel? {
    let json = JSON(rawObject)
    guard let id = json["id"].int else { return nil }
    guard let title = json["title"].string else { return nil }
    guard let image = json["poster_path"].string else { return nil }
    guard let date = json["release_date"].string else { return nil }
    guard let genres = json["genres"].array?.compactMap({ (item) -> String? in
      return item["name"].string
    }).joined(separator: ", ") else { return nil }
    guard let overview = json["overview"].string else { return nil }
    
    return MovieModel(id: id, name: title, image: image, date: date, genres: genres, overview: overview)
  }
  
  static func getVideoId(from rawObject: Any) -> String? {
    let json = JSON(rawObject)
    guard let result = json["results"].array else { return nil }
    return result.compactMap({ (item) -> String? in
      return item["key"].string
      }).first
  }
}
