//
//  DataState.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation

enum DataState {
  case loading(title: String, message: String)
  case loadingRemaining
  case done
  case failed(title: String, message: String)
  case noData(title: String, message: String)
  
  var isDone: Bool {
    switch self {
    case .done:
      return true
    default:
      return false
    }
  }
  
  var isFailed: Bool {
    switch self {
    case .failed(_ , _):
      return true
    default:
      return false
    }
  }
  
  var isLoading: Bool {
    switch self {
    case .loading(_ , _):
      return true
    default:
      return false
    }
  }
  
}

