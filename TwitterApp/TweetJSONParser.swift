//
//  TweetJSONParser.swift
//  TwitterApp
//
//  Created by mike davis on 8/3/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

class TweetJSONParser {

  class func parseJSONData(jsonData: NSData) -> [Tweet]? {
    var tweets = [Tweet]()
    var error: NSError?
    if let rootObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as? [[String:AnyObject]] {
      for tweetOrReTweetDictionary in rootObject {
        var retweet = false
        var tweetDictionary = tweetOrReTweetDictionary
        if let retweetDictionary = tweetOrReTweetDictionary[TweetJSONKeys.retweetStatus] as? [String:AnyObject] {
          tweetDictionary = retweetDictionary
          retweet = true
        }
        if let text = tweetDictionary[TweetJSONKeys.text] as? String, createdAt = tweetDictionary[TweetJSONKeys.createdAt] as? String, id = tweetDictionary[TweetJSONKeys.id] as? String, userDictionary = tweetDictionary[TweetJSONKeys.user] as? [String:AnyObject], name = userDictionary[UserJSONKeys.name] as? String {
          let screenName = userDictionary[UserJSONKeys.screenName] as? String
          let profileImageURL = userDictionary[UserJSONKeys.profileImageURL] as? String
          let user = User(name: name, screenName: screenName, profileImageURL: profileImageURL)
          let tweet = Tweet(text: text, createdAt: createdAt, id: id, user: user, retweet: retweet)
          println("tweet from \(name) \(retweet)")
          tweets.append(tweet)
        }
      }
      return tweets
    }
    if let error = error {
      println(error.description)
    }
    return nil
  }
}