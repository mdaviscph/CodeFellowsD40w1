//
//  User.swift
//  TwitterApp
//
//  Created by mike davis on 8/3/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

struct User {
  let name: String
  let screenName: String?
  let description: String?
  let location: String?
  let profileImageURL: String?
}

struct UserJSONKeys {
  static let name = "name"
  static let screenName = "screen_name"
  static let description = "description"
  static let location = "location"
  static let profileImageURL = "profile_image_url"
}