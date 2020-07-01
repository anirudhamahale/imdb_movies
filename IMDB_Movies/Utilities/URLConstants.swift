//
//  URLConstants.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation

struct APPURL {
  
  private enum Environment {
    enum dev {
      static let baseURL = "https://api.themoviedb.org/3"
      static let imageRoute = "https://image.tmdb.org/t/p/w500"
    }
  }
  
  private struct APICalls {
    static let environment = Environment.dev.self
    static let baseURL = environment.baseURL
    static let imageRoute = environment.imageRoute
    
    static let popularMoviesList = "/movie/popular"
    static let movieDetails = "/movie"
  }
  
  static var popularMoviesList: String {
    return APICalls.baseURL + APICalls.popularMoviesList
  }
  
  static var movieDetails: String {
    return APICalls.baseURL + APICalls.movieDetails
  }
  
  static var imageRoute: String {
    return APICalls.imageRoute
  }
  
}

