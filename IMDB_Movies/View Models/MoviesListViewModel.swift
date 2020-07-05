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
  
  // Table data properties.
  private(set) var movieListSection = RxAnimatableTableSectionModel(header: "movieListSection", rows: [])
  var displayData = BehaviorRelay<[RxAnimatableTableSectionModel]>.init(value: [])
  
  // Indicates wether more movies are remaining.
  var moreRemaining = true
  
  // Observable that provides lis of movies to the filter view.
  private let searchDisplayDataSubject = PublishSubject<[MovieItemTableCellModel]>()
  var searchDisplayData: Observable<[MovieItemTableCellModel]> {
    return searchDisplayDataSubject.asObserver()
  }
  
  // Observable that provides Text to Toasts.
  private let toastMessageSubject = PublishSubject<String>()
  var message: Observable<String> {
    return toastMessageSubject.asObserver()
  }
  
  // Observable that provides Status of the Refresh controller.
  let refreshing = BehaviorRelay<Bool>(value: false)
  
  private var dataProvider: MovieDataProvider
  
  private(set) var movies: [MovieModel] = []
  private(set) var filteredMovies: [MovieModel] = []
  private(set) var currentPage = 1
  
  init(dataProvider: MovieDataProvider) {
    self.dataProvider = dataProvider
  }
  
  func getMovies(completion: (()->())? = nil) {
    // If there are no more movies to download then just show toast and return.
    if !moreRemaining {
      toastMessageSubject.onNext(StringConstant.noMoreMovies)
      completion?()
      return
    }
    // If the movies count is zero then show loading UI.
    if movies.count == 0 {
      emptyDatastate.accept(loadingState)
    } else {
      // If the movies count is greater then zero then show load activity indicator at the end of list.
      let section = RxAnimatableTableSectionModel(header: "loading", rows: [ActivityIndicatorTableModel()])
      displayData.accept([movieListSection, section])
      emptyDatastate.accept(.loadingRemaining)
    }
    dataProvider.getMovies(page: currentPage)
      .subscribe { [weak self] (event) in
        guard let this = self else { return }
        if let result = event.element {
          self?.parseMovieListingResponse(result)
          completion?()
        }
        if let error = event.error {
          if this.movies.count == 0 {
            // If the movie list count is zero then show error message.
            this.emptyDatastate.accept(.failed(title: this.failedTitle, message: error.localizedDescription))
          } else {
            // If the movie list count is greater then zero then just show toast message and refresh UI.
            this.toastMessageSubject.onNext(error.localizedDescription)
            this.appendAndRefreshList([])
          }
          completion?()
        }
    }.disposed(by: disposeBag)
  }
  
  /// Refreshs the movies list.
  func refreshMovies(completion: (()->())? = nil) {
    refreshing.accept(true)
    dataProvider.getMovies(page: 1)
      .subscribe { [weak self] (event) in
        guard let this = self else { return }
        this.refreshing.accept(false)
        if let result = event.element {
          self?.parseMovieListingResponse(result, isRefresh: true)
          completion?()
        }
        if let error = event.error {
          this.toastMessageSubject.onNext(error.localizedDescription)
          this.appendAndRefreshList([])
          completion?()
        }
    }.disposed(by: disposeBag)
  }
  
  /// Appends the movies to the data source and refreshes the UI.
  /// - Parameter items: List of movies to append to the data source.
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
  
  /// Filters the movies and updates the data source based on the string provided.
  /// - Parameter string: The string based on which the movies to filter.
  func filterMovies(for string: String) {
    let searchString = string.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    // Filter the movies based on movie name.
    filteredMovies = movies.filter({ $0.name.contains(searchString) })
    let filteredOptions = filteredMovies.map({ MovieItemTableCellModel.from($0) })
    // Updating the data source.
    searchDisplayDataSubject.onNext(filteredOptions)
  }
  
  /// Returns an instance of MovieModel, containing movie details..
  /// - Parameters:
  ///   - index: Index of movie from the respsected list
  ///   - isSearchActive: Indicates wether the search is active.
  func getMovie(for index: Int, isSearchActive: Bool = false) -> MovieModel {
    if isSearchActive {
      return filteredMovies[index]
    } else {
      return movies[index]
    }
  }
  
  /// Handles the response given by the movies listing call.
  /// - Parameters:
  ///   - result: It contains the list of movies & boolean indicating wether result is loaded from remote database.
  ///   - isRefresh: True Indicates that this method is called from response of refresh call.
  func parseMovieListingResponse(_ result: ([MovieModel], Bool), isRefresh: Bool = false) {
    let newMovies = result.0
    currentPage += 1
    
    // If the response if of refresh call then empty the data source and record list.
    if isRefresh {
      currentPage = 2
      movies = []
      movieListSection.rows = []
    }
    
    // Appending the new movies list.
    movies.append(contentsOf: newMovies)
    appendAndRefreshList(newMovies)
    
    // Setting if more movies are remaining.
    moreRemaining = newMovies.count > 0 && result.1 == true
    
    // Showing offline message if the movies are loaded from local storage.
    checkForNetworkStatus(result.1)
  }
  
  /// Shows the status message to the toast.
  /// - Parameter online: True indicates that the results are fetched from remote database.
  func checkForNetworkStatus(_ online: Bool) {
    if !online {
      toastMessageSubject.onNext(StringConstant.offline)
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


