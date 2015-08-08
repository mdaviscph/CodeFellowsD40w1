//
//  Tweet.swift
//  TwitterApp
//
//  Created by mike davis on 8/3/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

// needs to be a class because of recursive reference to Tweet
class Tweet {
  let text: String
  let createdAt: String
  let id: String
  let user: User?
  let retweet: Tweet?

  init(text: String, createdAt: String, id: String, user: User?, retweet: Tweet?) {
    self.text = text
    self.createdAt = createdAt
    self.id = id
    self.user = user
    self.retweet = retweet
  }
}


struct TweetJSONKeys {
  static let text = "text"
  static let createdAt = "created_at"
  static let id = "id_str"
  static let retweetStatus = "retweeted_status"
  static let user = "user"
}