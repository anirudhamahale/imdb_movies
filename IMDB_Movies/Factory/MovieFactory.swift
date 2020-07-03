//
//  MovieFactory.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation

class MovieFactory: BaseFactory {
  static func toWidget(_ object: MovieRealmModel) -> MovieModel {
    return MovieModel(id: object.id,
                      name: object.name,
                      image: object.image,
                      date: object.date,
                      genres: object.genres,
                      overview: object.overview)
  }
}
