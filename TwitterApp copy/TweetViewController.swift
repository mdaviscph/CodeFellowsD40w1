//
//  TweetViewController.swift
//  TwitterApp
//
//  Created by mike davis on 8/3/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

  var tweets = [[Tweet]]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //if let jsonData = TweetJSONFile.loadJSONFileInBundle("tweet", fileType: "json"),
    //    latestTweets = TweetJSONParser.parseJSONData(jsonData) {
    //  tweets.insert(latestTweets, atIndex: 0)
    //}
    
    LoginService.loginForTwitter { (errorMessage, account) -> Void in
      if let errorMessage = errorMessage {
        println(errorMessage)
      } else {
        if let account = account {
          TwitterJSONRequest.tweetsFromHomeTimeline(account) { (errorMessage, latestTweets) -> Void in
            if let latestTweets = latestTweets {
              NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.tweets.insert(latestTweets, atIndex: 0)
              }
            }
          }
        }
      }
    }
  }
}

extension TweetViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return tweets.count
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets[section].count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardConsts.TweetTableViewCellReuseIdentifier, forIndexPath: indexPath) as? UITableViewCell {
      cell.textLabel?.text = tweets[indexPath.section][indexPath.row].text
      cell.detailTextLabel?.text = tweets[indexPath.section][indexPath.row].user?.name
      return cell
    }
  return UITableViewCell()
  }
}
