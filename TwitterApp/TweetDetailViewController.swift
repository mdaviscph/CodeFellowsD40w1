//
//  TweetDetailViewController.swift
//  TwitterApp
//
//  Created by mike davis on 8/6/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var theTextLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
    
  var tweet: Tweet? {
    didSet {
      updateUI()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  func updateUI() {
    nameLabel?.text = tweet?.user?.name
    theTextLabel?.text = tweet?.text
    if let screenName = tweet?.user?.screenName {
      screenNameLabel?.text = "@" + screenName
    }
  }
}
