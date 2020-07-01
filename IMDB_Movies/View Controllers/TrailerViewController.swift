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
    vc.viewModel = TrailerViewModel(movieId: movieID)
    return vc
  }
  
  @IBOutlet weak var playerView: YTPlayerView!
  var viewModel: TrailerViewModel!
  
  override func setupView() {
    super.setupView()
    
    configureEmptyDataSetView(on: playerView)
    playerView.delegate = self
  }
  
  override func bindViews() {
    super.bindViews()
    
    viewModel.emptyDatastate
      .subscribe { [weak self] (event) in
        guard let this = self else { return }
        if let event = event.element {
          switch event {
          case .loading(let title, let description):
            this.emptyDataSetView?.setProgress(title: title, description: description)
          case .noData(let title, let description):
            this.emptyDataSetView?.setNoData(image: nil, title: title, description: description)
          case .failed(let title, let message):
            this.emptyDataSetView?.setFailed(image: nil, title: title, description: message, buttonTitle: "Retry")
            this.emptyDataSetView?.didTapActionButton
              .subscribe(onNext: { [weak self] in
                self?.viewModel.getVideoId()
              }).disposed(by: this.emptyDataSetView!.disposeBag)
          default:
            this.emptyDataSetView?.hide()
          }
        }
    }.disposed(by: disposeBag)
    
    viewModel.videoId
      .subscribe(onNext: { [weak self] videoID in
        self?.playVideo(with: videoID)
      }).disposed(by: viewModel.disposeBag)
  }
  
  override func finishedLoading() {
    super.finishedLoading()
    
    viewModel.getVideoId()
  }
  
  @IBAction func didTapDone(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
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
    playerView.playVideo()
    viewModel.playerReady()
  }
  
  func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
    if state == .ended {
      self.dismiss(animated: true, completion: nil)
    }
  }
}
