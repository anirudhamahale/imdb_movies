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
  private var movieListSection = RxAnimatableTableSectionModel(header: "movieListSection", rows: [])
  var displayData = BehaviorRelay<[RxAnimatableTableSectionModel]>.init(value: [])
  var moreRemaining = false
  
  private let searchDisplayDataSubject = PublishSubject<[MovieItemTableCellModel]>()
  var searchDisplayData: Observable<[MovieItemTableCellModel]> {
    return searchDisplayDataSubject.asObserver()
  }
  
  private let dataProvider = MovieDataProvider()
  
  private var movies: [MovieModel] = []
  private var filteredMovies: [MovieModel] = []
  private var currentPage = 1
  
  func getMovies() {
    if movies.count == 0 {
      emptyDatastate.accept(loadingState)
    } else {
      let section = RxAnimatableTableSectionModel(header: "loading", rows: [ActivityIndicatorTableModel()])
      displayData.accept([movieListSection, section])
      emptyDatastate.accept(.loadingRemaining)
    }
    dataProvider.getMovies(page: currentPage)
      .subscribe { [weak self] (event) in
        guard let this = self else { return }
        if let result = event.element {
          let newMovies = result.0
          this.currentPage += 1
          this.movies.append(contentsOf: newMovies)
          this.appendAndRefreshList(newMovies)
          this.moreRemaining = newMovies.count > 0 && result.1 == true
        }
        if let error = event.error {
          if this.movies.count == 0 {
            this.emptyDatastate.accept(.failed(title: this.failedTitle, message: error.localizedDescription))
          } else {
            this.appendAndRefreshList([])
          }
        }
    }.disposed(by: disposeBag)
  }
  
  private func appendAndRefreshList(_ items: [MovieModel]) {
    items.forEach { (item) in
      movieListSection.rows.append(MovieItemTableCellModel.from(item))
    }
    if movieListSection.rows.count == 0 {
      emptyDatastate.accept(noDataState)
    } else {
      emptyDatastate.accept(.done)
      displayData.accept([movieListSection])
    }
  }
  
  func filterMovies(for string: String) {
    let searchString = string.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    filteredMovies = movies.filter({ $0.name.contains(searchString) })
    let filteredOptions = filteredMovies.map({ MovieItemTableCellModel.from($0) })
    searchDisplayDataSubject.onNext(filteredOptions)
  }
  
  func getMovie(for index: Int, isSearchActive: Bool = false) -> MovieModel {
    if isSearchActive {
      return filteredMovies[index]
    } else {
      return movies[index]
    }
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


