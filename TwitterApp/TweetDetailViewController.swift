//
//  TweetDetailViewController.swift
//  TwitterApp
//
//  Created by mike davis on 8/6/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

  var tweet: Tweet? {
    didSet {
      updateUI()
    }
  }
  var imagesDownloadedDelegate: RefreshWhenImagesDownloaded?
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var theTextLabel: UILabel!
  @IBOutlet weak var profileImageButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagesDownloadedDelegate = self
    updateUI()
  }
  
  private func updateUI() {
    if let retweet = tweet?.retweet {
      updateTextUI(name: retweet.user?.name, text: retweet.text, screenName: retweet.user?.screenName)
      if let profileImageURL = retweet.user?.profileImageURL, imageView = profileImageButton {
        updateProfileImageUI(profileImageURL, size: imageView.bounds.size)
      }
    }
    else {
      updateTextUI(name: tweet?.user?.name, text: tweet?.text, screenName: tweet?.user?.screenName)
      if let profileImageURL = tweet?.user?.profileImageURL, imageView = profileImageButton {
        updateProfileImageUI(profileImageURL, size: imageView.bounds.size)
      }
    }
  }
  private func updateTextUI(#name: String?, text: String?, screenName: String?) {
    nameLabel?.text = name
    theTextLabel?.text = text
    if let screenName = screenName {
      screenNameLabel?.text = "@" + screenName
    }
  }
  private func updateProfileImageUI(profileImageURL: String, size: CGSize) {
    let scale = UIScreen.mainScreen().scale
    let resize: CGSize
    switch scale {
    case 2:
      resize = CGSize(width: size.width*2, height: size.height*2)
    case 3:
      resize = CGSize(width: size.width*3, height: size.height*3)
    default:
      resize = size
    }
    let image = ProfileImageCache.sharedInstance.image(profileImageURL, size: resize) { (imageURL) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.imagesDownloadedDelegate?.refreshUIThatUsesImage(imageURL)
      }
    }
    profileImageButton.setBackgroundImage(image, forState: UIControlState.Normal)
  }
}

extension TweetDetailViewController: RefreshWhenImagesDownloaded {
  func refreshUIThatUsesImage(imageURL: String) {
    updateUI()
  }
}
