//
//  ViewController.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
  
  deinit {
    if ProcessInfo.processInfo.environment["deinit_log"] == "" {
      print(String(describing: self) + " 🔥")
    }
  }
  
  let disposeBag = DisposeBag()
  var emptyDataSetView: MEmptyDataSetView?
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    setupView()
    bindViews()
    finishedLoading()
    
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  /// Adds Empty data set to the view heirarchy.
  /// - Parameters:
  ///   - view: Adds the EmtpyData set View relative to this views position.
  ///   - insets: The amount of padding needed.
  func addEmptyDataSetView(on view: UIView? = nil, insets: UIEdgeInsets? = nil) {
    let parentView = view ?? self.view
    emptyDataSetView = MEmptyDataSetView()
    emptyDataSetView?.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(emptyDataSetView!)
    
    [emptyDataSetView?.topAnchor.constraint(equalTo: parentView!.topAnchor, constant: insets?.top ?? 0),
     emptyDataSetView?.trailingAnchor.constraint(equalTo: parentView!.trailingAnchor, constant: insets?.right ?? 0),
     emptyDataSetView?.leadingAnchor.constraint(equalTo: parentView!.leadingAnchor, constant: insets?.left ?? 0),
     emptyDataSetView?.bottomAnchor.constraint(equalTo: parentView!.bottomAnchor, constant: insets?.bottom ?? 0)].forEach { $0?.isActive = true }
    
    self.view.layoutIfNeeded()
  }
  
  /// This methods handles the showing of repsected UI for particular event.
  /// - Parameter viewModel: An instance of ViewModel.
  func configureEmptyData(for viewModel: ViewModel) {
    viewModel.emptyDatastate
      .subscribe { [weak self] (event) in
        if let event = event.element {
          switch event {
          case .loading(let title, let description):
            self?.emptyDataSetView?.setProgress(title: title, description: description)
          case .noData(let title, let description):
            self?.emptyDataSetView?.setNoData(image: nil, title: title, description: description)
          case .failed(let title, let message):
            self?.emptyDataSetView?.setFailed(image: nil, title: title, description: message, buttonTitle: "Retry")
          default:
            self?.emptyDataSetView?.hide()
          }
        }
    }.disposed(by: viewModel.disposeBag)
  }
  
  /// Method to add & configure of UI elements.
  func setupView() {}
  
  /// Method to bind UI Elements to the view model's output.
  func bindViews() {}
  
  /// This method is called once setting and binding of UI is done.
  func finishedLoading() {}
  
  /// Shows Toast.
  /// - Parameters:
  ///   - message: Message to be displayed on Toasts.
  ///   - seconds: Duration of the toast, default is set to 2 seconds.
  func showToast(message: String, seconds: Double = 2) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
    self.present(alert, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
      alert.dismiss(animated: true)
    }
  }
  
}

