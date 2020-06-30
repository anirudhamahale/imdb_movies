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
  func getMovies(page: Int) -> Observable<[MovieModel]> {
    let url = APPURL.popularMoviesList
    let params: [String : Any] = ["page": page, "api_key": StringConstant.api_key]
    return get(url, parameters: params)
      .map { (response) -> [MovieModel] in
        return MovieJSONMapper.getMoviesListFrom(from: response.1)
    }
  }
}
