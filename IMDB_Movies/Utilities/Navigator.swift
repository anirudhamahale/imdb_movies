//
//  Navigator.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit

struct Navigator {
  
  struct storyboards {
    static let main = UIStoryboard(name: "Main", bundle: nil)
  }
  
  static var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
}
