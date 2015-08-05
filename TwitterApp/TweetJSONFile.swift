//
//  TweetJSONFile.swift
//  TwitterApp
//
//  Created by mike davis on 8/4/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

class TweetJSONFile {
  class func loadJSONFileInBundle(fileName: String, fileType: String) -> NSData? {
    if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType), jsonData = NSData(contentsOfFile: filePath) {
      return jsonData
    }
    else {
      return nil
    }
  }
}