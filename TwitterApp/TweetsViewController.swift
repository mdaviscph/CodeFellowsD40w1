//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by mike davis on 8/3/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

  var tweets = [[Tweet]]() {
    didSet {
      tableView.reloadData()
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
    
    //if let jsonData = TweetJSONFile.loadJSONFileInBundle("tweet", fileType: "json"),
    //    latestTweets = TweetJSONParser.parseJSONData(jsonData) {
    //  tweets.insert(latestTweets, atIndex: 0)
    //}
    
    TwitterJSONRequest.tweetsFromTimeline(TwitterURLConsts.statusesHomeTimeline) { (errorMessage, latestTweets) -> Void in
      if let latestTweets = latestTweets {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
          self.tweets.insert(latestTweets, atIndex: 0)
        }
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == StoryboardConsts.TweetDetailSegueIdentifier, let detailVC = segue.destinationViewController as? TweetDetailViewController, indexPath = tableView.indexPathForSelectedRow() {
      detailVC.tweet = tweets[indexPath.section][indexPath.row]
    }
  }
}

extension TweetsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return tweets.count
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets[section].count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardConsts.TweetTableViewCellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
    cell.tweet = tweets[indexPath.section][indexPath.row]
    cell.imagesDownloadedDelegate = self
    return cell
  }
}

extension TweetsViewController: RefreshWhenImagesDownloaded {
  func refreshUIThatUsesImage(imageURL: String) {
    tableView.reloadData()
  }
}
