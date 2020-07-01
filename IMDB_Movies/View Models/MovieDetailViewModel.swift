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
  
  var emptyDatastate = BehaviorRelay<DataState>.init(value: .loading(title: "", message: ""))
  var movieId: Int
  
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
  
  private func populateViews(_ movie: MovieModel) {
    title.accept(movie.name)
    genres.accept(movie.genres)
    date.accept(movie.date)
    overview.accept(movie.overview)
    
    let thumbnailUrl = APPURL.imageRoute + movie.image
    if let url = URL(string: thumbnailUrl) {
      // imageUrl.onNext(url)
    }
    // https://image.tmdb.org/t/p/w500/jMO1icztaUUEUApdAQx0cZOt7b8.jpg
  }
  
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
