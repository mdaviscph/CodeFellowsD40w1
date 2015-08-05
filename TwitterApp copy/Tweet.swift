//
//  Tweet.swift
//  TwitterApp
//
//  Created by mike davis on 8/3/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

struct Tweet {
  let text: String
  let id: String
  let user: User?
}

struct TweetJSONKeys {
  static let text = "text"
  static let id = "id_str"
  static let user = "user"
}