//
//  ViewModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
  deinit {
    if ProcessInfo.processInfo.environment["deinit_log"] == "" {
      print(String(describing: self) + " 🔥")
    }
  }
  
  let disposeBag = DisposeBag()
  
}
