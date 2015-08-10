//
//  TweetTableViewCell.swift
//  TwitterApp
//
//  Created by mike davis on 8/6/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
  
  var imagesDownloadedDelegate: RefreshWhenImagesDownloaded?

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var theTextLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  
  var tweet: Tweet? {
    didSet {
      updateUI()
    }
  }
  
  private func updateUI() {
    updateTextUI(name: tweet?.user?.name, text: tweet?.text, screenName: tweet?.user?.screenName, createdAt: tweet?.createdAt)
    if let profileImageURL = tweet?.user?.profileImageURL, imageView = profileImageView {
      updateProfileImageUI(profileImageURL, size: imageView.bounds.size)
    }
  }
  private func updateTextUI(#name: String?, text: String?, screenName: String?, createdAt: String?) {
    nameLabel?.text = name
    theTextLabel?.text = text
    if let screenName = screenName {
      screenNameLabel?.text = "@" + screenName
    }
    if let createdAt = createdAt {
      // twitter UTC string example : "Wed Aug 27 13:08:45 +0000 2008"
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "EEE LLL d HH:mm:ss +0000 yyyy zzz"
      if let date = dateFormatter.dateFromString(createdAt + " UTC") {
        let interval = -date.timeIntervalSinceNow
        let seconds = Int(interval)
        let minutes = Int(interval/60)
        let hours = Int(interval/3600)
        createdAtLabel?.text = (hours > 0) ? "\(hours)hr" : (minutes > 0) ? "\(minutes)m" : "\(seconds)s"
      }
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
    profileImageView.image = ProfileImageCache.sharedInstance.image(profileImageURL, size: resize) { (stringURL) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.imagesDownloadedDelegate?.refreshUIThatUsesImage(stringURL)
      }
    }
  }
}
