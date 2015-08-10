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
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.estimatedRowHeight = 140 //change from setting to tableView.rowHeight due to using Nib
      tableView.rowHeight = UITableViewAutomaticDimension
    }
  }
  @IBOutlet weak var busyIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateUI()
    
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
  
  private func updateUI() {
    updateTextUI(name: user?.name, screenName: user?.screenName, description: user?.description, location: user?.location)
    if let profileImageURL = user?.profileImageURL, imageView = profileImageView {
      updateProfileImageUI(profileImageURL, size: imageView.bounds.size)
    }
    tableView?.reloadData()
  }
  private func updateTextUI(#name: String?, screenName: String?, description: String?, location: String?) {
    nameLabel?.text = name
    descriptionLabel?.text = description
    locationLabel?.text = location
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
    let image = ProfileImageCache.sharedInstance.image(profileImageURL, size: resize) { (stringURL) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        self.refreshUIThatUsesImage(stringURL)
      }
    }
    profileImageView.image = image
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == StoryboardConsts.UserTimelineDetailSegueIdentifier, let detailVC = segue.destinationViewController as? UserTimelineTweetDetailViewController, indexPath = tableView.indexPathForSelectedRow() {
      detailVC.imagesDownloadedDelegate = self
      detailVC.tweet = tweets[indexPath.section][indexPath.row]
    }
  }
}

extension UserTimelineTweetsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier(StoryboardConsts.UserTimelineDetailSegueIdentifier, sender: tableView)
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
    cell.imagesDownloadedDelegate = self  // must do this before assigning to cell.tweet due to didSet calling updateUI
    cell.tweet = tweets[indexPath.section][indexPath.row]
    cell.selectionStyle = .None
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
    updateUI()
  }
}

