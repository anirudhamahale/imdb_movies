//
//  MovieDetailViewModelTest.swift
//  IMDB_MoviesTests
//
//  Created by Anirudha Mahale on 02/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

@testable import IMDB_Movies
import XCTest

class MovieDetailViewModelTest: XCTestCase {
  
  var viewModel: MovieDetailViewModel!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    viewModel = MovieDetailViewModel(movieId: 259316, dataProvider: FakeMovieDataProvider())
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewModel = nil
  }
  
  func testMovieDetails() {
    let expect = expectation(description: "Fetch movies call should returns movies.")
    viewModel.getMovieDetails {
      expect.fulfill()
    }
    waitForExpectations(timeout: 60, handler: nil)
    
    let movie = FakeMovieDataProvider.fakeMovie
    XCTAssertEqual(viewModel.title.value, movie.name)
    XCTAssertEqual(viewModel.genres.value, movie.genres)
    XCTAssertEqual(viewModel.date.value, movie.date)
    XCTAssertEqual(viewModel.overview.value, movie.overview)
  }
  
}
