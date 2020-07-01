//
//  MovieDataProvider.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxSwift

class MovieDataProvider: DataProvider {
  
  let remoteDataProvider = MovieRemoteDataProvider()
  let localDataProvider = MovieLocalDbProvider()
  
  func getMovies(page: Int) -> Observable<([MovieModel], Bool)> {
    return remoteDataProvider.getMovies(page: page)
      .map { [weak self] (movies) -> ([MovieModel], Bool) in
        // If page is one that then remove all the saved movies from the database and add new.
        if page == 1 {
          self?.localDataProvider.removeAllMovies()
        }
        // Saving movies to the database.
        self?.localDataProvider.addMovies(movies: movies)
        return (movies, true)
    }.catchError { [weak self] (error) -> Observable<([MovieModel], Bool)> in
      guard let this = self else { throw error }
      // If network error and page is equal to one then only populate the data from database.
      if NumberConstants.networkErrorCodes.contains(error.code) && page == 1 {
        return this.localDataProvider.getMovies().map({ ($0, false) })
      } else {
        throw error
      }
    }
  }
  
  func getMovieDetails(for movieId: Int) -> Observable<MovieModel> {
    return remoteDataProvider.getMovieDetails(for: movieId)
    .map { [weak self] (movie) -> MovieModel in
        // Saving movies to the database.
        self?.localDataProvider.setMoviesProperties(movie)
        return movie
    }.catchError { [weak self] (error) -> Observable<MovieModel> in
      guard let this = self else { throw error }
      if NumberConstants.networkErrorCodes.contains(error.code) {
        return this.localDataProvider.getMovieDetails(for: movieId)
      } else {
        throw error
      }
    }
  }
  
  func getVideoId(from movieId: Int) -> Observable<String> {
    return remoteDataProvider.getVideoId(from: movieId)
  }
  
  func test() -> Observable<([MovieModel], Bool)> {
    return remoteDataProvider.getMovies(page: 0)
      .map { (movies) -> ([MovieModel], Bool) in
        return (movies, true)
    }.catchError { [weak self] (error) -> Observable<([MovieModel], Bool)> in
      guard let this = self else { throw error }
      if NumberConstants.networkErrorCodes.contains(error.code) {
        return this.localDataProvider.getMovies().map({ ($0, false) })
      } else {
        throw error
      }
    }
  }
}
