//
//  MovieDetailViewController.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit

class MovieDetailViewController: ViewController {
  
  @IBOutlet weak var movieImageView: UIImageView!
  @IBOutlet weak var movieLabel: UILabel!
  @IBOutlet weak var watchTrailerButton: UIButton!
  @IBOutlet weak var genresLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  
  static func initalise() -> MovieDetailViewController {
    let vc = Navigator.storyboards.main.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
    return vc
  }
  
}
