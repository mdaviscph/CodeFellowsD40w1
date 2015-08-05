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
        if let text = tweetDictionary[TweetJSONKeys.text] as? String, id = tweetDictionary[TweetJSONKeys.id] as? String, userDictionary = tweetDictionary[TweetJSONKeys.user] as? [String:AnyObject], name = userDictionary[UserJSONKeys.name] as? String, profileImageURL = userDictionary[UserJSONKeys.profileImageURL] as? String {
          let user = User(name: name, profileImageURL: profileImageURL)
          let tweet = Tweet(text: text, id: id, user: user)
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