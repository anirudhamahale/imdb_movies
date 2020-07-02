//
//  TrailerViewModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources

class TrailerViewModel: ViewModel {
  
  private(set) var movieId: Int
  
  let videoId = BehaviorRelay<String>(value: "")
  private let dataProvider = MovieDataProvider()
  
  init(movieId: Int) {
    self.movieId = movieId
    super.init()
  }
  
  /// Fetchs the video id based.
  func getVideoId() {
    emptyDatastate.accept(loadingState)
    dataProvider.getVideoId(from: movieId)
    .subscribe { [weak self] (event) in
        if let videoId = event.element {
          self?.videoId.accept(videoId)
        }
        if let error = event.error {
          self?.showFailedMessage(with: error.localizedDescription)
        }
    }.disposed(by: disposeBag)
  }
  
  /// Show error message.
  /// - Parameter error: error message to display.
  private func showFailedMessage(with error: String) {
    emptyDatastate.accept(.failed(title: failedTitle, message: error))
  }
  
  /// Player ready event.
  func playerReady() {
    emptyDatastate.accept(.done)
  }
}

extension TrailerViewModel {
  var loadingState: DataState {
    let title = "Fetching trailer link"
    let message = "Please wait while we load trailer link for you."
    return DataState.loading(title: title, message: message)
  }
  
  var noDataState: DataState {
    let title = "No Trailers found"
    let message = ""
    return DataState.noData(title: title, message: message)
  }
  
  var failedTitle: String {
    return "Failed to get Link."
  }
}
