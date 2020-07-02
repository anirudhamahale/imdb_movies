//
//  MovieListViewModelTest.swift
//  IMDB_MoviesTests
//
//  Created by Anirudha Mahale on 02/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

@testable import IMDB_Movies
import XCTest

class MovieListViewModelTest: XCTestCase {
  
  var viewModel: MoviesListViewModel!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    viewModel = MoviesListViewModel(dataProvider: FakeMovieDataProvider())
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewModel = nil
  }
  
  func testFetchMovies() {
    let expect = expectation(description: "Fetch movies call should returns movies.")
    viewModel.getMovies {
      expect.fulfill()
    }
    waitForExpectations(timeout: 60, handler: nil)
    XCTAssertGreaterThan(viewModel.movies.count, 0)
  }
  
  func testRefreshWorks() {
    let expect = expectation(description: "Refresh movies call should returns movies.")
    viewModel.refreshMovies {
      expect.fulfill()
    }
    waitForExpectations(timeout: 60, handler: nil)
    XCTAssertGreaterThan(viewModel.movies.count, 0)
    
  }
  
  func testMoviesCount() {
    let expect = expectation(description: "Movies count should be equal to 3.")
    viewModel.getMovies {
      expect.fulfill()
    }
    waitForExpectations(timeout: 60, handler: nil)
    XCTAssertEqual(viewModel.movies.count, 3)
  }
  
  func testMovieListCountForRefresh() {
    let expect = expectation(description: "Movie datasource and List count should be same.")
    viewModel.refreshMovies {
      expect.fulfill()
    }
    waitForExpectations(timeout: 60, handler: nil)
    XCTAssertEqual(viewModel.movieListSection.rows.count, viewModel.movies.count)
  }
}
