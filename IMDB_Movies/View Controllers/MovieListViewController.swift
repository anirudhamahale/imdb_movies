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
  var searchBarButton: UIBarButtonItem!
  var movieFilterSearchController : UISearchController!
  var resultController: UITableViewController!
  
  let viewModel = MoviesListViewModel()
  
  override func setupView() {
    super.setupView()
    
    setupRightButton()
    
    tableView.registerCell(with: "MovieItemTableViewCell")
    tableView.registerCell(with: "ActivityIndicatorTableViewCell")
    tableView.estimatedRowHeight = 100
    tableView.estimatedSectionHeaderHeight = 0
    tableView.estimatedSectionFooterHeight = 0
    
    addEmptyDataSetView()
    setupSearchController()
  }
  
  override func bindViews() {
    super.bindViews()
    
    configureEmptyData(for: viewModel)
    
    emptyDataSetView?.didTapActionButton
    .subscribe(onNext: { [weak self] in
      self?.viewModel.getMovies()
    }).disposed(by: emptyDataSetView!.disposeBag)
    
    viewModel.displayData
      .bind(to: tableView.rx.items(dataSource: getDataSource()))
      .disposed(by: disposeBag)
    
    tableView.rx
      .contentOffset
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
    
    tableView.rx
      .itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        self?.pushMovieDetailView(for: indexPath.row)
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
          cell.startAnimating()
          return cell
          
        default:
          return UITableViewCell()
        }
    })
    return dataSource
  }
  
  private func setupRightButton() {
    searchBarButton = UIBarButtonItem(image: Images.search, style: .done, target: self, action: #selector(self.showSearchBar))
    self.navigationItem.rightBarButtonItem = searchBarButton
  }
  
  private func setupSearchController() {
    resultController = storyboard?.instantiateViewController(withIdentifier: "SearchMovieResultController") as? UITableViewController
    movieFilterSearchController = UISearchController(searchResultsController: resultController)
    
    let tableView = resultController.tableView!
    tableView.registerCell(with: "MovieItemTableViewCell")
    tableView.dataSource = nil
    tableView.delegate = nil
    
    viewModel.searchDisplayData
      .bind(to: tableView.rx.items(cellIdentifier: "MovieItemTableViewCell")) { (index, model: MovieItemTableCellModel, cell: MovieItemTableViewCell) in
        cell.data = model
    }
    .disposed(by: disposeBag)
    
    if #available(iOS 11.0, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    } else {
      // Fallback on earlier versions
    }
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.tableHeaderView = UIView(frame: .zero)
    tableView.sectionHeaderHeight = .zero
    tableView.sectionFooterHeight = .zero
    
    let searchBar = movieFilterSearchController.searchBar
    searchBar.placeholder = "Filter Movies"
    searchBar.barTintColor = Colors.primary
    searchBar.tintColor = UIColor.white
    searchBar.isTranslucent = false
    
    if let textField = movieFilterSearchController.searchBar.value(forKey: "searchField") as? UITextField {
      textField.tintColor = .white
      textField.textColor = .white
      textField.leftView?.tintColor = .white
      textField.rightView?.tintColor = .white
    }
    movieFilterSearchController.obscuresBackgroundDuringPresentation = true
    movieFilterSearchController.hidesNavigationBarDuringPresentation = false
    movieFilterSearchController.searchBar.sizeToFit()
    
    movieFilterSearchController.searchBar
      .rx
      .text
      .subscribe(onNext: { [weak self] text in
        self?.viewModel.filterMovies(for: text ?? "")
      }).disposed(by: disposeBag)
    
    tableView.rx
    .itemSelected
    .subscribe(onNext: { [weak self] indexPath in
      self?.movieFilterSearchController.dismiss(animated: false, completion: nil)
      self?.pushMovieDetailView(for: indexPath.row, isSearchActive: true)
    }).disposed(by: disposeBag)
  }
  
  @objc func showSearchBar() {
    self.present(movieFilterSearchController, animated: true, completion: nil)
  }
  
  private func pushMovieDetailView(for index: Int, isSearchActive: Bool = false) {
    let movieId = viewModel.getMovie(for: index, isSearchActive: isSearchActive).id
    let vc = MovieDetailViewController.initalise(with: movieId)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}
