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
    }
  }
  
  private struct APICalls {
    static let environment = Environment.dev.self
    static let baseURL = environment.baseURL
    
    static let popularMoviesList = "/movie/popular"
  }
  
  static var popularMoviesList: String {
    return APICalls.baseURL + APICalls.popularMoviesList
  }
  
}

