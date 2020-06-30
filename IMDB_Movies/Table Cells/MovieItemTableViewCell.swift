//
//  MovieItemTableViewCell.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit

class MovieItemTableViewCell: UITableViewCell {

  @IBOutlet weak var movieImageView: UIImageView!
  @IBOutlet weak var movieTitleLabel: UILabel!
  
  var data: MovieItemTableCellModel! {
    didSet {
      movieTitleLabel.text = data.title
      movieImageView.setImage(with: data.thumbnailUrl, placeholderImage: Images.placeholder)
    }
  }
}

class MovieItemTableCellModel: RxAnimatableTableCellModel {
  
  var title: String
  var thumbnailUrl: URL?
  
  init(id: String, title: String, thumbnailUrl: URL?) {
    self.title = title
    self.thumbnailUrl = thumbnailUrl
    super.init()
    super.id = id
  }
  
  static func from(_ item: MovieModel) -> MovieItemTableCellModel {
    let thumbnailUrl = APPURL.imageRoute + item.image
    let url = URL(string: thumbnailUrl)
    return MovieItemTableCellModel(id: "\(item.id)", title: item.name, thumbnailUrl: url)
  }
}
