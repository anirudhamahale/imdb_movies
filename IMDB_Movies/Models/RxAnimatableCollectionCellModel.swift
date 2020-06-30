//
//  RxAnimatableCollectionCellModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class RxAnimatableCollectionCellModel: IdentifiableType, Equatable {
  var identity: String {
    return id
  }
  
  var id = ""
  typealias Identity = String
  
  static func == (lhs: RxAnimatableCollectionCellModel, rhs: RxAnimatableCollectionCellModel) -> Bool {
    return lhs.id == rhs.id
  }
  
  func getIndex(from constant: String) -> Int? {
    let stringIndex = identity.replacingOccurrences(of: constant, with: "")
    return Int(stringIndex)
  }
}
