//
//  FakeMovieDataProvider.swift
//  IMDB_MoviesTests
//
//  Created by Anirudha Mahale on 02/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
@testable import IMDB_Movies
import RxSwift

class FakeMovieDataProvider: MovieDataProvider {
  
  static let fakeMovie = MovieModel(id: 259316,
                             name: "Fantastic Beasts and Where to Find Them",
                             image: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/h6NYfVUyM6CDURtZSnBpz647Ldd.jpg",
                             date: "11/18/2016",
                             genres: "Adventure, Family, Fantasy",
                             overview: "In 1926, Newt Scamander arrives at the Magical Congress of the United States of America with a magically expanded briefcase, which houses a number of dangerous creatures and their habitats. When the creatures escape from the briefcase, it sends the American wizarding authorities after Newt, and threatens to strain even further the state of magical and non-magical relations.")
  
  override func getMovies(page: Int) -> Observable<([MovieModel], Bool)> {
    let moviesList = [MovieModel(id: 1, name: "", image: "", date: "", genres: "", overview: ""),
                      MovieModel(id: 1, name: "", image: "", date: "", genres: "", overview: ""),
                      MovieModel(id: 1, name: "", image: "", date: "", genres: "", overview: "")]
    return Observable.of((moviesList, true))
  }
  
  override func getMovieDetails(for movieId: Int) -> Observable<MovieModel> {
    if movieId == FakeMovieDataProvider.fakeMovie.id {
      return .of(FakeMovieDataProvider.fakeMovie)
    } else {
      return .error(CError.create(code: 404, description: StringConstant.noMovie))
    }
  }
}
