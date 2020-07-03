//
//  Error.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation

extension Error {
  var code: Int { return (self as NSError).code }
  var domain: String { return (self as NSError).domain }
}
