//
//  TweetTableViewCell.swift
//  TwitterApp
//
//  Created by mike davis on 8/6/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var hoursOldLabel: UILabel!
  @IBOutlet weak var theTextLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  
  var tweet: Tweet? {
    didSet {
      nameLabel.text = tweet?.user?.name
      theTextLabel.text = tweet?.text
      if let screenName = tweet?.user?.screenName {
        screenNameLabel.text = "@" + screenName
      }
    }
  }
}
