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
    vc.viewModel = TrailerViewModel(movieId: movieID, dataProvider: MovieDataProvider())
    return vc
  }
  
  @IBOutlet weak var playerView: YTPlayerView!
  var viewModel: TrailerViewModel!
  
  override func setupView() {
    super.setupView()
    
    addEmptyDataSetView(on: playerView)
    playerView.delegate = self
  }
  
  override func bindViews() {
    super.bindViews()
    
    configureEmptyData(for: viewModel)
    
    emptyDataSetView?.didTapActionButton
    .subscribe(onNext: { [weak self] in
      self?.viewModel.getVideoId()
    }).disposed(by: emptyDataSetView!.disposeBag)
    
    // Callback to get video id.
    viewModel.videoId
      .subscribe(onNext: { [weak self] videoID in
        self?.playVideo(with: videoID)
      }).disposed(by: viewModel.disposeBag)
  }
  
  override func finishedLoading() {
    super.finishedLoading()
    
    // Calling getVideoId to fetch the video id.
    viewModel.getVideoId()
  }
  
  @IBAction func didTapDone(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  /// Loads the vidoe player with the provided id.
  /// - Parameter id: Youtube id of the video.
  private func playVideo(with id: String) {
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
    
    playerView.load(withVideoId: id, playerVars: playerVars)
  }
}

extension TrailerViewController: YTPlayerViewDelegate {
  func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
    // Player has loaded the video & ready to stream it.
    playerView.playVideo()
    viewModel.playerReady()
  }
  
  func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
    if state == .ended {
      // As the video has ended dismissing the view.
      self.dismiss(animated: true, completion: nil)
    }
  }
}
