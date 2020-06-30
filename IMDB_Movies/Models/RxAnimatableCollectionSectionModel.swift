//
//  RxAnimatableCollectionSectionModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

struct RxAnimatableCollectionSectionModel {
  var header: String
  var rows: [RxAnimatableCollectionCellModel]
}

extension RxAnimatableCollectionSectionModel: AnimatableSectionModelType {
  
  typealias Item = RxAnimatableCollectionCellModel
  typealias Identity = String
  var items: [RxAnimatableCollectionCellModel] {
    return rows
  }
  
  var identity: String {
    return header
  }
  
  init(original: RxAnimatableCollectionSectionModel, items: [RxAnimatableCollectionCellModel]) {
    self = original
    self.rows = items
  }
}


