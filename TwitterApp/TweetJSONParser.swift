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
      for tweetDictionary in rootObject {
        var retweet: Tweet?
        if let text = tweetDictionary[TweetJSONKeys.text] as? String, createdAt = tweetDictionary[TweetJSONKeys.createdAt] as? String, id = tweetDictionary[TweetJSONKeys.id] as? String, userDictionary = tweetDictionary[TweetJSONKeys.user] as? [String:AnyObject], name = userDictionary[UserJSONKeys.name] as? String {
          // check for retweet; should move duplicate code to function
          if let tweetDictionary = tweetDictionary[TweetJSONKeys.retweetStatus] as? [String:AnyObject], text = tweetDictionary[TweetJSONKeys.text] as? String, createdAt = tweetDictionary[TweetJSONKeys.createdAt] as? String, id = tweetDictionary[TweetJSONKeys.id] as? String, userDictionary = tweetDictionary[TweetJSONKeys.user] as? [String:AnyObject], name = userDictionary[UserJSONKeys.name] as? String {
            let screenName = userDictionary[UserJSONKeys.screenName] as? String
            let description = userDictionary[UserJSONKeys.description] as? String
            let location = userDictionary[UserJSONKeys.location] as? String
            let profileImageURL = userDictionary[UserJSONKeys.profileImageURL] as? String
            let user = User(name: name, screenName: screenName, description: description, location: location, profileImageURL: profileImageURL)
            retweet = Tweet(text: text, createdAt: createdAt, id: id, user: user, retweet: nil)
            //println("retweet from \(name)")
          }
          let screenName = userDictionary[UserJSONKeys.screenName] as? String
          let description = userDictionary[UserJSONKeys.description] as? String
          let location = userDictionary[UserJSONKeys.location] as? String
          let profileImageURL = userDictionary[UserJSONKeys.profileImageURL] as? String
          let user = User(name: name, screenName: screenName, description: description, location: location, profileImageURL: profileImageURL)
          let tweet = Tweet(text: text, createdAt: createdAt, id: id, user: user, retweet: retweet)
          //println("tweet from \(name)")
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