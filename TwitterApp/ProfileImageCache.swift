//
//  ProfileImageCache.swift
//  TwitterApp
//
//  Created by mike davis on 8/7/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class ProfileImageCache {
  
  static let sharedInstance = ProfileImageCache()
  func clear() {
    imageCache.removeAll()
    imageRequested.removeAll()
  }
  func image(stringURL: String, size: CGSize, completionHandler: (String) -> Void) -> UIImage? {
    let key = stringURL + "\(size.width)\(size.height)"
    if let value = imageCache[key] {
      imageRequested[key] = nil
      println("cached image returned: \(key)")
      return value
    }
    else if let requested = imageRequested[key] where requested {
      return nil
    }
    else {
      println(stringURL)
      backgroundQueue.addOperationWithBlock { () -> Void in
        if let URL = NSURL(string: stringURL), data = NSData(contentsOfURL: URL), image = UIImage(data: data) {
          // fastest way to resize an image; from nshipster.com
          UIGraphicsBeginImageContext(size)
          image.drawInRect(CGRect(origin: CGPoint.zeroPoint, size: size))
          let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          self.imageCache[key] = resizedImage
          println("image returned: \(key)")
          completionHandler(stringURL)
        }
      }
      imageRequested[key] = true
      return nil
    }
  }
  
  private init () {}
  private var imageCache = [String:UIImage]()
  private var imageRequested = [String:Bool]()
  private lazy var backgroundQueue = NSOperationQueue()
}