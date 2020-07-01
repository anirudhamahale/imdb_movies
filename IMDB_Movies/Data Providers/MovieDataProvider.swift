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
  
  func getMovies(page: Int) -> Observable<[MovieModel]> {
    return remoteDataProvider.getMovies(page: page)
  }
  
  func getMovieDetails(for movieId: Int) -> Observable<MovieModel> {
    return remoteDataProvider.getMovieDetails(for: movieId)
  }
}
