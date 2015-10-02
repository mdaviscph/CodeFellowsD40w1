//
//  TwitterJSONRequest.swift
//  TwitterApp
//
//  Created by mike davis on 8/4/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation
import Accounts
import Social

class TwitterJSONRequest {
  static let sharedInstance = TwitterJSONRequest()
  private var account: ACAccount?
  private init() {}
  
  class func tweetsFromTimeline(stringURL: String, parameters: [String:String]?, completionHandler: (String?, [Tweet]?) -> Void) {
    if let account = sharedInstance.account {
      let twitterTimelineURL = NSURL(string: stringURL)
      let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: twitterTimelineURL, parameters: parameters)
      request.account = account
      request.performRequestWithHandler { (data, response, error) -> Void in
        if let error = error {
          let code = " (\(error.code))"
          completionHandler(ErrorMessageConsts.noConnection + code, nil)
        } else {
          let status = " (\(response.statusCode))"
          switch response.statusCode {
          case 200...299:
            if let tweets = TweetJSONParser.parseJSONData(data) {
              completionHandler(nil, tweets)
            } else {
              completionHandler(ErrorMessageConsts.badData + status, nil)
            }
          case 300...399:
            // no new data
            completionHandler(nil, nil)
          case 400...499:
            completionHandler(ErrorMessageConsts.noAuthorization + status, nil)
          case 500...599:
            completionHandler(ErrorMessageConsts.busyOrServerError + status, nil)
          default:
            completionHandler(ErrorMessageConsts.busyOrServerError + status, nil)
          }
        }
      }
    } else {
      LoginService.loginForTwitter { (errorMessage, account) -> Void in
        if let errorMessage = errorMessage {
          print(errorMessage)
        } else {
          self.sharedInstance.account = account
          self.tweetsFromTimeline(stringURL, parameters: parameters, completionHandler: completionHandler)
        }
      }
    }
  }
}
