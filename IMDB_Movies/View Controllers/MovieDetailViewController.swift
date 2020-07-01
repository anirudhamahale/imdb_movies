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
    
    configureEmptyDataSetView()
  }
  
  override func bindViews() {
    super.bindViews()
    
    viewModel.emptyDatastate
      .subscribe { [weak self] (event) in
        guard let this = self else { return }
        if let event = event.element {
          switch event {
          case .loading(let title, let description):
            this.emptyDataSetView?.setProgress(title: title, description: description)
          case .noData(let title, let description):
            this.emptyDataSetView?.setNoData(image: nil, title: title, description: description)
          case .failed(let title, let message):
            this.emptyDataSetView?.setFailed(image: nil, title: title, description: message, buttonTitle: "Retry")
            this.emptyDataSetView?.didTapActionButton
              .subscribe(onNext: { [weak self] in
                self?.viewModel.getMovieDetails()
              }).disposed(by: this.emptyDataSetView!.disposeBag)
          default:
            this.emptyDataSetView?.hide()
          }
        }
    }.disposed(by: disposeBag)
    
    bind(label: movieLabel, to: viewModel.title)
    bind(label: genresLabel, to: viewModel.genres)
    bind(label: dateLabel, to: viewModel.date)
    bind(label: overviewLabel, to: viewModel.overview)
    
    viewModel.imageUrl
      .subscribe(onNext: { [weak self] url in
        self?.movieImageView.setImage(with: url, placeholderImage: Images.placeholder)
      }).disposed(by: viewModel.disposeBag)
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
}
