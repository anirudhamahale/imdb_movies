//
//  UIImageView.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
  func setImage(with url: URL?, placeholderImage: UIImage) {
    if let url = url {
      self.sd_setImage(with: url, placeholderImage: placeholderImage, options: [.queryMemoryData, .allowInvalidSSLCertificates, .refreshCached], progress: nil, completed: nil)
    } else {
      self.image = placeholderImage
    }
  }
}
