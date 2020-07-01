//
//  MovieLocalDbProvider.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm

class MovieLocalDbProvider: LocalDbProvider {
  
  func addMovies(movies: [MovieModel]) {
    try! getInstance().write {
      movies.forEach { (movie) in
        let realmMovie = MovieRealmModel()
        realmMovie.id = movie.id
        realmMovie.setAllProperties(movie)
        getInstance().add(realmMovie)
      }
    }
  }
  
  func removeAllMovies() {
    try! getInstance().write {
      getInstance().delete(getInstance().objects(MovieRealmModel.self))
    }
  }
  
  func getMovies() -> Observable<[MovieModel]> {
    Observable.collection(from: getInstance().objects(MovieRealmModel.self))
      .map { data -> [MovieModel] in
        return data.map({ (item) -> MovieModel in
          return MovieFactory.toWidget(item)
        }).toArray()
    }
  }
  
  func getMovieDetails(for movieId: Int) -> Observable<MovieModel> {
    if let object = getInstance().objects(MovieRealmModel.self).filter("id = %@", movieId).first {
      return Observable.of(object)
        .map({ (data) -> MovieModel in
          return MovieFactory.toWidget(data)
        })
    } else {
      return Observable.error(CError.create(code: 404, description: StringConstant.noMovie))
    }
  }
  
  func setMoviesProperties(_ movie: MovieModel) {
    let answerObjects = getInstance().objects(MovieRealmModel.self).filter("id = %@", movie.id)
    try! getInstance().write {
      answerObjects.forEach {
        $0.setAllProperties(movie)
      }
    }
  }
}
