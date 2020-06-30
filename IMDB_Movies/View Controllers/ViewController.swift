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
  
  func bindViews() {
    
  }
  
}

