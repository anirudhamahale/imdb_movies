//
//  MovieListViewController.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit

class MovieListViewController: ViewController {
  
  let viewModel = MoviesListViewModel()
  
  override func setupView() {
    super.setupView()
    
    configureEmptyDataSetView()
  }
  
  override func bindViews() {
    super.bindViews()
    
    viewModel.state
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
                self?.viewModel.getMovies()
              }).disposed(by: this.emptyDataSetView!.disposeBag)
          default:
            this.emptyDataSetView?.hide()
          }
        }
    }.disposed(by: disposeBag)
  }
  
  override func finishedLoading() {
    super.finishedLoading()
    viewModel.getMovies()
  }
}
