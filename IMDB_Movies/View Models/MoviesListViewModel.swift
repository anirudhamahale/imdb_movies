//
//  MoviesListViewModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class MoviesListViewModel: ViewModel {
  
  // Table data
  private var data: [RxAnimatableCollectionSectionModel] = []
  var displayData = BehaviorRelay<[RxAnimatableCollectionSectionModel]>.init(value: [])
  var state = BehaviorRelay<DataState>.init(value: .loading(title: "", message: ""))
  
  private let dataProvider = MovieDataProvider()
  
  private var movies: [MovieModel] = []
  
  func getMovies() {
    if movies.count == 0 {
      state.accept(loadingState)
    } else {
      
    }
    dataProvider.getMovies(page: 1)
      .subscribe { [weak self] (event) in
        guard let this = self else { return }
        if let list = event.element {
          this.movies.append(contentsOf: list)
          // this.state.accept(.done)
        }
        if let error = event.error {
          this.state.accept(.failed(title: this.failedTitle, message: error.localizedDescription))
        }
    }.disposed(by: disposeBag)
  }
  
}

extension MoviesListViewModel {
  var loadingState: DataState {
    let title = "Loading Movies"
    let message = "Please wait while we load movies for you."
    return DataState.loading(title: title, message: message)
  }
  
  var noDataState: DataState {
    let title = "No Movies found"
    let message = ""
    return DataState.noData(title: title, message: message)
  }
  
  var failedTitle: String {
    return "Failed to get Movies."
  }
}


