//
//  CFont.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import UIKit

struct CFont {
  struct OpenSans {
    static func bold(size: CGFloat) -> UIFont {
      return UIFont(name: "OpenSans-Bold", size: size)!
    }
    static func regular(size: CGFloat) -> UIFont {
      return UIFont(name: "OpenSans-regular", size: size)!
    }
  }
}
