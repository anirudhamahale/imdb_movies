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
  
  /// Remote data provider
  let remoteDataProvider = MovieRemoteDataProvider()
  
  /// Local data provider
  let localDataProvider = MovieLocalDbProvider()
  
  /// Returns an Observable with list of movies and a boolean indicating if the data is loaded from remote database.
  /// - Parameter page: Represents from which page movies to download.
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
  
  /// Returns an Observable with the movies details.
  /// - Parameter movieId: The movie id to download the particular movie.
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
  
  /// Returns an Observable with containing video id.
  /// - Parameter movieId: The movie id based on it will retrive the video id.
  func getVideoId(from movieId: Int) -> Observable<String> {
    return remoteDataProvider.getVideoId(from: movieId)
  }
}
