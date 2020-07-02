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
  
  /// Adds movie to the local database.
  /// - Parameter movies: List of movies to save.
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
  
  /// Removes all the movies from the database.
  func removeAllMovies() {
    try! getInstance().write {
      getInstance().delete(getInstance().objects(MovieRealmModel.self))
    }
  }
  
  /// Returns an Observable of list of movies.
  func getMovies() -> Observable<[MovieModel]> {
    Observable.collection(from: getInstance().objects(MovieRealmModel.self))
      .map { data -> [MovieModel] in
        return data.map({ (item) -> MovieModel in
          return MovieFactory.toWidget(item)
        }).toArray()
    }
  }
  
  /// Returns an Observable of MovieModel
  /// - Parameter movieId: The movie id based on which particular movie to retrive.
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
  
  /// Set the movie propertie to the movie given.
  /// - Parameter movie: Movie to whos property to set.
  func setMoviesProperties(_ movie: MovieModel) {
    let answerObjects = getInstance().objects(MovieRealmModel.self).filter("id = %@", movie.id)
    try! getInstance().write {
      answerObjects.forEach {
        $0.setAllProperties(movie)
      }
    }
  }
}
