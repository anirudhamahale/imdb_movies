//
//  MovieRemoteDataProvider.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxSwift

class MovieRemoteDataProvider: RemoteDataProvider {
  
  /// Returns an Observable of MovieModel based on it's page.
  /// - Parameter page: Movies to download from particular page.
  func getMovies(page: Int) -> Observable<[MovieModel]> {
    let url = APPURL.popularMoviesList
    let params: [String : Any] = ["page": page, "api_key": StringConstant.api_key]
    return get(url, parameters: params)
      .map { (response) -> [MovieModel] in
        return MovieJSONMapper.getMoviesListFrom(from: response.1)
    }
  }
  
  /// Returns an Observable of MovieModel based on the movie id.
  /// - Parameter movieId: The movie id to download the particular movie.
  func getMovieDetails(for movieId: Int) -> Observable<MovieModel> {
    let url = APPURL.movieDetails + "/\(movieId)"
    let params = ["api_key": StringConstant.api_key]
    return get(url, parameters: params)
      .map { (response) -> MovieModel in
        if let movie = MovieJSONMapper.getMovieDetailFrom(from: response.1) {
          return movie
        }
        throw CError.create(code: 400, description: StringConstant.invalidJSON)
    }
  }
  
  /// Returns an Observable of  video id.
  /// - Parameter movieId: The movie id based on it will retrive the video id.
  func getVideoId(from movieId: Int) -> Observable<String> {
    let url = APPURL.movieDetails + "/\(movieId)" + "/videos"
    let params = ["api_key": StringConstant.api_key]
    return get(url, parameters: params)
      .map { (response) -> String in
        if let videoId = MovieJSONMapper.getVideoId(from: response.1) {
          return videoId
        }
        throw CError.create(code: 400, description: StringConstant.invalidJSON)
    }
  }
}
