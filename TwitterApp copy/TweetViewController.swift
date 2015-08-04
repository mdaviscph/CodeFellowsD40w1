//
//  TweetViewController.swift
//  TwitterApp
//
//  Created by mike davis on 8/3/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

  var tweets = [[Tweet]]()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let latestTweets = TweetJSONParser.parseJSONBundleFile("tweet", fileType: "json") {
      tweets.insert(latestTweets, atIndex: 0)
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
