//
//  CError.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation

class CError {
  static func create(code: Int, description: String) -> Error {
    return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: description])
  }
}
