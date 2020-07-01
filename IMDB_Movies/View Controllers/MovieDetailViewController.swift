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
    
    bind(label: movieLabel, to: viewModel.title)
    bind(label: genresLabel, to: viewModel.genres)
    bind(label: dateLabel, to: viewModel.date)
    bind(label: overviewLabel, to: viewModel.overview)
    
    viewModel.imageUrl
      .subscribe(onNext: { [weak self] url in
        self?.movieImageView.setImage(with: url, placeholderImage: Images.placeholder)
      }).disposed(by: viewModel.disposeBag)
    
    watchTrailerButton.rx
      .tap
      .subscribe(onNext: { [weak self] _ in
        self?.pushVideoPlayer()
      }).disposed(by: disposeBag)
  }
  
  override func finishedLoading() {
    super.finishedLoading()
    viewModel.getMovieDetails()
  }
  
  private func bind(label: UILabel, to relay: BehaviorRelay<String>) {
    relay.subscribe(onNext: { text in
      label.text = text
    }).disposed(by: viewModel.disposeBag)
  }
  
  private func pushVideoPlayer() {
    let vc = TrailerViewController.initalise(with: viewModel.movieId)
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
}
