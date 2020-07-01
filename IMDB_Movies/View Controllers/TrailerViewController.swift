//
//  TrailerViewController.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 01/07/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit
import RxSwift
import youtube_ios_player_helper

class TrailerViewController: ViewController {
  
  static func initalise(with movieID: Int) -> TrailerViewController {
    let vc = Navigator.storyboards.main.instantiateViewController(withIdentifier: "TrailerViewController") as! TrailerViewController
    return vc
  }
  
  @IBOutlet weak var playerView: YTPlayerView!
  
  override func setupView() {
    super.setupView()
    
    playerView.delegate = self
  }
  
  override func finishedLoading() {
    super.finishedLoading()
    
    // playerView.load(withVideoId: "7q6Co-nd0lM")
    
    let playerVars : Dictionary =
    ["playsinline": "0", // 1 in view or 0 fullscreen
    "autoplay": "1", // Auto-play the video on load
    "modestbranding": "0", // without button of youtube and giat branding
    "rel": "0",
    "controls": "0", // Show pause/play buttons in player
    "fs": "1", // Hide the full screen button
    "origin": "https://www.example.com",
    "cc_load_policy": "0", // Hide closed captions
    "iv_load_policy": "3", // Hide the Video Annotations
    "loop": "0",
    "version": "3",
    "playlist": "",
    "autohide": "0", // Hide video controls when playing
    "showinfo": "0"] // show related videos at the end // show related videos at the end
    
    playerView.load(withVideoId: "EAiXc6HoLhs", playerVars: playerVars)
  }
  
  @IBAction func didTapDone(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
}

extension TrailerViewController: YTPlayerViewDelegate {
  func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
    playerView.playVideo()
  }
  
  func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
    if state == .ended {
      self.dismiss(animated: true, completion: nil)
    }
  }
}
