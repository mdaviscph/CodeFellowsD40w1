//
//  UserTimelineTweetsViewController.swift
//  TwitterApp
//
//  Created by mike davis on 8/7/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class UserTimelineTweetsViewController: UIViewController {
  
  var user: User?
  var tweets = [[Tweet]]() {
    didSet {
      tableView?.reloadData()
    }
  }
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.estimatedRowHeight = tableView.rowHeight
      tableView.rowHeight = UITableViewAutomaticDimension
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let screenName = user?.screenName {
      let parameters = [UserJSONKeys.screenName:screenName]
      println("request \(TwitterURLConsts.statusesUserTimeline) with: \(parameters)")
      TwitterJSONRequest.tweetsFromTimeline(TwitterURLConsts.statusesUserTimeline, parameters: parameters) { (errorMessage, latestTweets) -> Void in
        if let latestTweets = latestTweets {
          NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.tweets.insert(latestTweets, atIndex: 0)
          }
        }
        if let errorMessage = errorMessage {
          // need to alert user via mainQueue alert popover
          println(errorMessage)
        }
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == StoryboardConsts.UserTimelineDetailSegueIdentifier, let detailVC = segue.destinationViewController as? UserTimelineTweetDetailViewController, indexPath = tableView.indexPathForSelectedRow() {
      detailVC.tweet = tweets[indexPath.section][indexPath.row]
    }
  }
}

extension UserTimelineTweetsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return tweets.count
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets[section].count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardConsts.UserTimelineTableViewCellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
    cell.tweet = tweets[indexPath.section][indexPath.row]
    cell.imagesDownloadedDelegate = self
    return cell
  }
}

extension UserTimelineTweetsViewController: RefreshWhenImagesDownloaded {
  func refreshUIThatUsesImage(imageURL: String) {
    tableView?.reloadData()
  }
}

