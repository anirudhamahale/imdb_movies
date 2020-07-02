//
//  MovieDetailViewModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class MovieDetailViewModel: ViewModel {
  
  private(set) var movieId: Int
  
  let title = BehaviorRelay<String>(value: "")
  let genres = BehaviorRelay<String>(value: "")
  let date = BehaviorRelay<String>(value: "")
  let overview = BehaviorRelay<String>(value: "")
  let imageUrl = PublishSubject<URL>()
  
  private let dataProvider = MovieDataProvider()
  
  init(movieId: Int) {
    self.movieId = movieId
    super.init()
  }
  
  /// Method to get movie details.
  func getMovieDetails() {
    emptyDatastate.accept(loadingState)
    dataProvider.getMovieDetails(for: movieId)
      .subscribe { [weak self] (event) in
        if let movie = event.element {
          self?.populateViews(movie)
          self?.emptyDatastate.accept(.done)
        }
        if let error = event.error {
          self?.showFailedMessage(with: error.localizedDescription)
        }
    }.disposed(by: disposeBag)
  }
  
  /// Populate the view from the model provided.
  /// - Parameter movie: Instance of movie model which will give the movie details.
  private func populateViews(_ movie: MovieModel) {
    title.accept(movie.name)
    if movie.genres.count == 0 {
      genres.accept(StringConstant.notSet)
    } else {
      genres.accept(movie.genres)
    }
    date.accept(movie.date)
    overview.accept(movie.overview)
    
    let thumbnailUrl = APPURL.imageRoute + movie.image
    if let url = URL(string: thumbnailUrl) {
      imageUrl.onNext(url)
    }
  }
  
  /// shows failed message.
  /// - Parameter error: error message to display.
  private func showFailedMessage(with error: String) {
    emptyDatastate.accept(.failed(title: failedTitle, message: error))
  }
}

extension MovieDetailViewModel {
  var loadingState: DataState {
    let title = "Loading Movie Details"
    let message = "Please wait while we load movie details for you."
    return DataState.loading(title: title, message: message)
  }
  
  var noDataState: DataState {
    let title = "No Movie found"
    let message = ""
    return DataState.noData(title: title, message: message)
  }
  
  var failedTitle: String {
    return "Failed to get Movie."
  }
}


