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
  let refreshControl = UIRefreshControl()
  
  let viewModel = MoviesListViewModel(dataProvider: MovieDataProvider())
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // To Prevent refresh controller from stop animating when pushed to detail view and returning back.
    if self.refreshControl.isRefreshing {
      let offset = tableView.contentOffset
      UIView.performWithoutAnimation {
        refreshControl.endRefreshing()
      }
      refreshControl.beginRefreshing()
      tableView.contentOffset = offset
    }
  }
  
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
    
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
  }
  
  override func bindViews() {
    super.bindViews()
    
    configureEmptyData(for: viewModel)
    
    emptyDataSetView?.didTapActionButton
      .subscribe(onNext: { [weak self] in
        self?.viewModel.getMovies()
      }).disposed(by: emptyDataSetView!.disposeBag)
    
    // Binds the datasource to the tableView.
    viewModel.displayData
      .bind(to: tableView.rx.items(dataSource: getDataSource()))
      .disposed(by: disposeBag)
    
    // Handling pagination.
    tableView.rx
      .contentOffset
      .throttle(.seconds(2), scheduler: MainScheduler.instance)
      .filter({ [weak self] (_) -> Bool in
        return self?.viewModel.emptyDatastate.value.isDone == true
      })
      .filter({ [weak self] (contentOffset) -> Bool in
        let offsetY = contentOffset.y
        let contentHeight = self?.tableView.contentSize.height ?? 0.0
        return offsetY > contentHeight - (self?.tableView.frame.height ?? 0.0)
      })
      .subscribe(onNext: { [weak self] contentOffset in
        self?.viewModel.getMovies()
      }).disposed(by: disposeBag)
    
    // Callback when item is selected from tableview.
    tableView.rx
      .itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        self?.pushMovieDetailView(for: indexPath.row)
      }).disposed(by: disposeBag)
    
    // Callback to show toasts.
    viewModel.message
      .subscribe(onNext: { [weak self] text in
        self?.showToast(message: text)
      }).disposed(by: viewModel.disposeBag)
    
    // Callback when refersh action is done.
    refreshControl.rx
      .controlEvent(.valueChanged)
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.refreshMovies()
      }).disposed(by: disposeBag)
    
    // Callback when refreshing status is changed
    viewModel.refreshing
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] refreshing in
        if refreshing {
          self?.refreshControl.beginRefreshing()
        } else {
          self?.refreshControl.endRefreshing()
        }
      }).disposed(by: viewModel.disposeBag)
  }
  
  override func finishedLoading() {
    super.finishedLoading()
    // calling the get movies list as view is finished loading.
    viewModel.getMovies()
  }
  
  // data source to the table view.
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
  
  /// Addes
  private func setupRightButton() {
    searchBarButton = UIBarButtonItem(image: Images.search, style: .done, target: self, action: #selector(self.presentSearchController))
    self.navigationItem.rightBarButtonItem = searchBarButton
  }
  
  /// Setups the search bar and handles it's callbacks.
  private func setupSearchController() {
    resultController = storyboard?.instantiateViewController(withIdentifier: "SearchMovieResultController") as? UITableViewController
    movieFilterSearchController = UISearchController(searchResultsController: resultController)
    
    let tableView = resultController.tableView!
    tableView.registerCell(with: "MovieItemTableViewCell")
    // Setting the datasource & delegate nil to prevent the crash as the below method will again set the datasource.
    tableView.dataSource = nil
    tableView.delegate = nil
    
    // Binds the search result datasource to the search controller's tableview.
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
    
    // Callback when text from the search bar is changed & in turn it calls the filter movie method.
    movieFilterSearchController.searchBar
      .rx
      .text
      .subscribe(onNext: { [weak self] text in
        self?.viewModel.filterMovies(for: text ?? "")
      }).disposed(by: disposeBag)
    
    // Callback when movie is selected from the search controller.
    tableView.rx
      .itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        self?.movieFilterSearchController.dismiss(animated: false, completion: nil)
        self?.pushMovieDetailView(for: indexPath.row, isSearchActive: true)
      }).disposed(by: disposeBag)
  }
  
  /// Presents the search controller.
  @objc func presentSearchController() {
    self.present(movieFilterSearchController, animated: true, completion: nil)
  }
  
  /// Push Movie Detail View.
  /// - Parameters:
  ///   - index: index of the selected item in the list.
  ///   - isSearchActive: Indicates wether search bar is active.
  private func pushMovieDetailView(for index: Int, isSearchActive: Bool = false) {
    let movieId = viewModel.getMovie(for: index, isSearchActive: isSearchActive).id
    let vc = MovieDetailViewController.initalise(with: movieId)
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
