//
//  MovieDetailViewController.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit
import RxCocoa

class MovieDetailViewController: ViewController {
  
  @IBOutlet weak var movieImageView: UIImageView!
  @IBOutlet weak var movieLabel: UILabel!
  @IBOutlet weak var watchTrailerButton: UIButton!
  @IBOutlet weak var genresLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  
  var viewModel: MovieDetailViewModel!
  
  static func initalise(with movieID: Int) -> MovieDetailViewController {
    let vc = Navigator.storyboards.main.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
    vc.viewModel = MovieDetailViewModel(movieId: movieID)
    return vc
  }
  
  override func setupView() {
    super.setupView()
    
    addEmptyDataSetView()
  }
  
  override func bindViews() {
    super.bindViews()
    
    configureEmptyData(for: viewModel)
    
    emptyDataSetView?.didTapActionButton
    .subscribe(onNext: { [weak self] in
      self?.viewModel.getMovieDetails()
    }).disposed(by: emptyDataSetView!.disposeBag)
    
    // Binds the UI elements to the observer.
    bind(label: movieLabel, to: viewModel.title)
    bind(label: genresLabel, to: viewModel.genres)
    bind(label: dateLabel, to: viewModel.date)
    bind(label: overviewLabel, to: viewModel.overview)
    
    // Binds the Image View to the observer.
    viewModel.imageUrl
      .subscribe(onNext: { [weak self] url in
        self?.movieImageView.setImage(with: url, placeholderImage: Images.placeholder)
      }).disposed(by: viewModel.disposeBag)
    
    // Callback when button is clicked & Play Trailer view will be pushed.
    watchTrailerButton.rx
      .tap
      .subscribe(onNext: { [weak self] _ in
        self?.pushVideoPlayer()
      }).disposed(by: disposeBag)
  }
  
  override func finishedLoading() {
    super.finishedLoading()
    // Calling getMoviesDetails as view is loaded.
    viewModel.getMovieDetails()
  }
  
  /// Binds the UI element to it's data source.
  /// - Parameters:
  ///   - label: Instance of UIlabel whom to bind with the datasource.
  ///   - relay: Instance of observable who will provide the data to the UI Element.
  private func bind(label: UILabel, to relay: BehaviorRelay<String>) {
    relay.subscribe(onNext: { text in
      label.text = text
    }).disposed(by: viewModel.disposeBag)
  }
  
  /// Push the Trailer View.
  private func pushVideoPlayer() {
    let vc = TrailerViewController.initalise(with: viewModel.movieId)
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
}
