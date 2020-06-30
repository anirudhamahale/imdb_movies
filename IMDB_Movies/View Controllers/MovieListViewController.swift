//
//  MovieListViewController.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MovieListViewController: ViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let viewModel = MoviesListViewModel()
  
  override func setupView() {
    super.setupView()
    
    tableView.registerCell(with: "MovieItemTableViewCell")
    tableView.registerCell(with: "ActivityIndicatorTableViewCell")
    tableView.estimatedRowHeight = 100
    tableView.estimatedSectionHeaderHeight = 0
    tableView.estimatedSectionFooterHeight = 0
    
    configureEmptyDataSetView()
  }
  
  override func bindViews() {
    super.bindViews()
    
    viewModel.displayData
    .bind(to: tableView.rx.items(dataSource: getDataSource()))
    .disposed(by: disposeBag)
    
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
                self?.viewModel.getMovies()
              }).disposed(by: this.emptyDataSetView!.disposeBag)
          default:
            this.emptyDataSetView?.hide()
          }
        }
    }.disposed(by: disposeBag)
    
    tableView.rx.contentOffset
    .filter({ [weak self] (_) -> Bool in
      return self?.viewModel.moreRemaining == true && self?.viewModel.emptyDatastate.value.isDone == true
    })
    .filter({ [weak self] (contentOffset) -> Bool in
      let offsetY = contentOffset.y
      let contentHeight = self?.tableView.contentSize.height ?? 0.0
      return offsetY > contentHeight - (self?.tableView.frame.height ?? 0.0)
    })
    .subscribe(onNext: { [weak self] contentOffset in
      self?.viewModel.getMovies()
    }).disposed(by: disposeBag)
  }
  
  override func finishedLoading() {
    super.finishedLoading()
    viewModel.getMovies()
  }
  
  func getDataSource() -> RxTableViewSectionedReloadDataSource<RxAnimatableTableSectionModel>! {
    let dataSource = RxTableViewSectionedReloadDataSource<RxAnimatableTableSectionModel>(
      configureCell: { dataSource, tableView, indexPath, item in
        switch item {
        case let model as MovieItemTableCellModel:
          let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as! MovieItemTableViewCell
          cell.data = model
          return cell
          
        case is ActivityIndicatorTableModel:
          let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityIndicatorTableViewCell", for: indexPath) as! ActivityIndicatorTableViewCell
          return cell
          
        default:
          return UITableViewCell()
        }
    })
    return dataSource
  }
}
