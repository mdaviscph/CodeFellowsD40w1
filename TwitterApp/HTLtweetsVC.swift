//
//  HomeTimelineTweetsViewController.swift
//  TwitterApp
//
//  Created by mike davis on 8/3/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class HomeTimelineTweetsViewController: UIViewController {

  var tweets = [[Tweet]]() {
    didSet {
      updateUI()
    }
  }
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.estimatedRowHeight = 140 //change from setting to tableView.rowHeight due to using Nib
      tableView.rowHeight = UITableViewAutomaticDimension
    }
  }
  @IBAction func homeTapped(sender: AnyObject) {
    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
    tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
  }
  @IBOutlet weak var busyIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateUI()
    
    let nib = UINib(nibName: StoryboardConsts.TimelineCellNibName, bundle: NSBundle.mainBundle())
    tableView.registerNib(nib, forCellReuseIdentifier: StoryboardConsts.TimelineCellReuseIdentifier)

    //if let jsonData = TweetJSONFile.loadJSONFileInBundle("tweet", fileType: "json"),
    //    latestTweets = TweetJSONParser.parseJSONData(jsonData) {
    //  tweets.insert(latestTweets, atIndex: 0)
    //}
    
    println("request: \(TwitterURLConsts.statusesHomeTimeline)")
    busyIndicator.startAnimating()
    TwitterJSONRequest.tweetsFromTimeline(TwitterURLConsts.statusesHomeTimeline, parameters: nil) { (errorMessage, latestTweets) -> Void in
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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    startObservingNotifications()
  }
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    stopObservingNotifications()
  }
  
  func updateUI() {
    tableView?.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == StoryboardConsts.HomeTimelineDetailSegueIdentifier, let detailVC = segue.destinationViewController as? HomeTimelineTweetDetailViewController, indexPath = tableView.indexPathForSelectedRow() {
      detailVC.tweet = tweets[indexPath.section][indexPath.row]
    }
  }
}

extension HomeTimelineTweetsViewController {
  func startObservingNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("updateUI"),
      name: UIContentSizeCategoryDidChangeNotification, object:nil)
  }
  func stopObservingNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)}
}

extension HomeTimelineTweetsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier(StoryboardConsts.HomeTimelineDetailSegueIdentifier, sender: tableView)
  }
}
extension HomeTimelineTweetsViewController: UITableViewDataSource {
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

extension HomeTimelineTweetsViewController: RefreshWhenImagesDownloaded {
  func refreshUIThatUsesImage(stringURL: String) {
    println("refreshing due to image: \(stringURL)")
    updateUI()
  }
}
