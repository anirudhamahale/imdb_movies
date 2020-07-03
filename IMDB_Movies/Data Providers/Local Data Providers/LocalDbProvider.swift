//
//  LocalDataProvider.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RealmSwift

class LocalDbProvider {
  
  var realm: Realm
  
  init() {
    self.realm = try! Realm()
  }
  
  /// Returns an instance of the database.
  func getInstance() -> Realm {
    return self.realm
  }
  
  /// Clears the database.
  func clearDatabase() {
    try! getInstance().write {
      getInstance().deleteAll()
    }
  }
}
