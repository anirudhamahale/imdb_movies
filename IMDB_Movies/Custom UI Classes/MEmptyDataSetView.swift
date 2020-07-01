//
//  MEmptyDataSetView.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MEmptyDataSetViewDelegate {
  func setProgress(title: String?, description: String?)
  func setNoData(image: UIImage?, title: String?, description: String?)
  func setFailed(image: UIImage?, title: String?, description: String?, buttonTitle: String?)
  func hide()
}

class MEmptyDataSetView: UIView, MEmptyDataSetViewDelegate {
  
  private(set) var parentView: UIView!
  private(set) var titleLabel: UILabel!
  private(set) var descriptionLabel: UILabel!
  private(set) var imageView: UIImageView!
  private(set) var button: UIButton = UIButton()
  let animationKey = "circularAnimation"
  let disposeBag = DisposeBag()
  
  private var imageAnimation: CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "transform")
    animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
    animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 0.0, 1.0))
    animation.duration = 0.25
    animation.isCumulative = true
    animation.repeatCount = MAXFLOAT
    animation.isRemovedOnCompletion = false
    return animation
  }
  
  private(set) var margin: CGFloat = 16.0
  
  var didTapActionButton: ControlEvent<Void> {
    let observable = button.rx.tap.map {  }
    return ControlEvent(events: observable)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loadView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    loadView()
  }
  
  private func loadView() {
    self.backgroundColor = .white
    
    parentView = UIView()
    parentView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(parentView)
    
    [parentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
     parentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
     parentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin)].forEach { $0.isActive = true }
  }
  
  func setProgress(title: String?, description: String?) {
    var topConstraint = parentView.topAnchor
    clearView()
    self.isHidden = false
    // Add Image
    topConstraint = addImageView(image: Images.circularLoader, shouldAnimate: true)
    // Add Title
    if let title = title {
      topConstraint = addTitleLabel(text: title, topConstraint: topConstraint)
    }
    // Add Description
    if let description = description {
      topConstraint = addDescriptionLabel(text: description, topConstraint: topConstraint)
    }
    parentView.bottomAnchor.constraint(equalTo: topConstraint).isActive = true
  }
  
  func setNoData(image: UIImage?, title: String?, description: String?) {
    var topConstraint = parentView.topAnchor
    clearView()
    self.isHidden = false
    // Add Image
    if let image = image {
      topConstraint = addImageView(image: image)
    }
    // Add Title
    if let title = title {
      topConstraint = addTitleLabel(text: title, topConstraint: topConstraint)
    }
    // Add Description
    if let description = description {
      topConstraint = addDescriptionLabel(text: description, topConstraint: topConstraint)
    }
    parentView.bottomAnchor.constraint(equalTo: topConstraint).isActive = true
  }
  
  func setFailed(image: UIImage?, title: String?, description: String?, buttonTitle: String?) {
    var topConstraint = parentView.topAnchor
    clearView()
    self.isHidden = false
    // Add Image
    if let image = image {
      topConstraint = addImageView(image: image)
    }
    // Add Title
    if let title = title {
      topConstraint = addTitleLabel(text: title, topConstraint: topConstraint)
    }
    // Add Description
    if let description = description {
      topConstraint = addDescriptionLabel(text: description, topConstraint: topConstraint)
    }
    // Add Button
    if let text = buttonTitle {
      topConstraint = addButton(title: text, topConstraint: topConstraint)
    }
    parentView.bottomAnchor.constraint(equalTo: topConstraint).isActive = true
    
    parentView.layoutIfNeeded()
  }
  
  func hide() {
    self.isHidden = true
  }
  
  private func clearView() {
    parentView.subviews.forEach { $0.removeFromSuperview() }
  }
  
  private func addImageView(image: UIImage, shouldAnimate: Bool = false) -> NSLayoutYAxisAnchor {
    imageView = UIImageView()
    imageView.tintColor = Colors.primary
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = image
    parentView.addSubview(imageView)
    imageView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0).isActive = true
    imageView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0).isActive = true
    if shouldAnimate {
      imageView.layer.add(imageAnimation, forKey: animationKey)
    } else {
      imageView.layer.removeAnimation(forKey: animationKey)
    }
    return imageView.bottomAnchor
  }
  
  private func addTitleLabel(text: String, topConstraint: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
    titleLabel = UILabel()
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = Colors.primary
    titleLabel.font = CFont.OpenSans.bold(size: 16)
    titleLabel.text = text
    
    parentView.addSubview(titleLabel)
    [titleLabel.topAnchor.constraint(equalTo: topConstraint, constant: margin),
     titleLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -margin),
     titleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: margin)].forEach { $0.isActive = true }
    
    return titleLabel.bottomAnchor
  }
  
  private func addDescriptionLabel(text: String, topConstraint: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
    descriptionLabel = UILabel()
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 4
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.font = CFont.OpenSans.regular(size: 14)
    descriptionLabel.textColor = Colors.primary
    descriptionLabel.text = text
    
    parentView.addSubview(descriptionLabel)
    [descriptionLabel.topAnchor.constraint(equalTo: topConstraint, constant: margin),
     descriptionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -margin),
     descriptionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: margin)].forEach { $0.isActive = true }
    return descriptionLabel.bottomAnchor
  }
  
  private func addButton(title: String, topConstraint: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
    button.translatesAutoresizingMaskIntoConstraints = false
    
    let baseView = UIView()
    baseView.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = Colors.primary
    
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = CFont.OpenSans.bold(size: 14)
    button.setTitleColor(.white, for: .normal)
    button.sizeToFit()
    
    button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 36, bottom: 10, right: 36)
    parentView.addSubview(baseView)
    
    baseView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0).isActive = true
    baseView.topAnchor.constraint(equalTo: topConstraint, constant: margin).isActive = true
    
    baseView.layoutIfNeeded()
    
    let borderView = UIView()
    baseView.addSubview(borderView)
    
    borderView.addSubview(button)
    [baseView.topAnchor.constraint(equalTo: button.topAnchor, constant: 0),
     baseView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 0),
     baseView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0),
     baseView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 0)].forEach { $0.isActive = true }
    
    baseView.layoutIfNeeded()
    
    borderView.frame = baseView.bounds
    borderView.layer.cornerRadius = 20
    borderView.layer.borderColor = Colors.primary.cgColor
    borderView.layer.borderWidth = 1.0
    borderView.layer.masksToBounds = true
    
    // add the shadow to the base view
    baseView.backgroundColor = UIColor.clear
    baseView.layer.shadowColor = Colors.primary.cgColor
    baseView.layer.shadowOffset = CGSize(width: 0, height: 3)
    baseView.layer.shadowOpacity = 0.6
    baseView.layer.shadowRadius = 4.0
    baseView.layer.shadowPath = UIBezierPath(roundedRect: baseView.bounds, cornerRadius: baseView.bounds.height/2.0).cgPath
    baseView.layer.shouldRasterize = true
    baseView.layer.rasterizationScale = UIScreen.main.scale
    
    return baseView.bottomAnchor
  }
}
