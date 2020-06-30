//
//  RxAnimatableTableSectionModel.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

struct RxAnimatableTableSectionModel {
  var header: String
  var rows: [RxAnimatableTableCellModel]
}

extension RxAnimatableTableSectionModel: AnimatableSectionModelType {
  
  typealias Item = RxAnimatableTableCellModel
  typealias Identity = String
  var items: [RxAnimatableTableCellModel] {
    return rows
  }
  
  var identity: String {
    return header
  }
  
  init(original: RxAnimatableTableSectionModel, items: [RxAnimatableTableCellModel]) {
    self = original
    self.rows = items
  }
}


