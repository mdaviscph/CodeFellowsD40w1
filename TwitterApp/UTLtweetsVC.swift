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
      tableView.estimatedRowHeight = 140 //change from setting to tableView.rowHeight due to using Nib
      tableView.rowHeight = UITableViewAutomaticDimension
    }
  }
  @IBOutlet weak var busyIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib = UINib(nibName: StoryboardConsts.TimelineCellNibName, bundle: NSBundle.mainBundle())
    tableView.registerNib(nib, forCellReuseIdentifier: StoryboardConsts.TimelineCellReuseIdentifier)
    
    if let screenName = user?.screenName {
      let parameters = [UserJSONKeys.screenName:screenName]
      println("request \(TwitterURLConsts.statusesUserTimeline) with: \(parameters)")
      busyIndicator.startAnimating()
      TwitterJSONRequest.tweetsFromTimeline(TwitterURLConsts.statusesUserTimeline, parameters: parameters) { (errorMessage, latestTweets) -> Void in
        if let latestTweets = latestTweets {
          NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.busyIndicator.stopAnimating()
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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    startObservingNotifications()
  }
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    stopObservingNotifications()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == StoryboardConsts.UserTimelineDetailSegueIdentifier, let detailVC = segue.destinationViewController as? UserTimelineTweetDetailViewController, indexPath = tableView.indexPathForSelectedRow() {
      detailVC.tweet = tweets[indexPath.section][indexPath.row]
    }
  }
}

extension UserTimelineTweetsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier(StoryboardConsts.HomeTimelineDetailSegueIdentifier, sender: tableView)
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
    let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardConsts.TimelineCellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
    cell.tweet = tweets[indexPath.section][indexPath.row]
    cell.imagesDownloadedDelegate = self
    return cell
  }
}

extension UserTimelineTweetsViewController {
  func startObservingNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("updateUI"),
      name: UIContentSizeCategoryDidChangeNotification, object:nil)
  }
  func stopObservingNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)}
}

extension UserTimelineTweetsViewController: RefreshWhenImagesDownloaded {
  func refreshUIThatUsesImage(stringURL: String) {
    println("refreshing due to image: \(stringURL)")
    tableView?.reloadData()
  }
}

