//
//  ProfileImageCache.swift
//  TwitterApp
//
//  Created by mike davis on 8/7/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class ProfileImageCache {
  
  private init () {
    if backgroundQueue.operationCount == 0 {
      let serialQueue = dispatch_queue_create("com.mdaviscph.imageSerialQueue", DISPATCH_QUEUE_SERIAL)
      backgroundQueue.underlyingQueue = serialQueue
    }
  }
  private var imageCache = [String:UIImage]()
  private var imageRequested = [String:Bool]()
  private lazy var backgroundQueue = NSOperationQueue()
  
  static let sharedInstance = ProfileImageCache()
  
  func clear() {
    imageCache.removeAll()
    imageRequested.removeAll()
  }
  
  func image(stringURL: String, size: CGSize, completionHandler: (String) -> Void) -> UIImage? {
    if let imageURL = imageURLBiggerIsBetter(stringURL) {
      let stringBigURL = imageURL.absoluteString
      let key = stringBigURL + "\(Int(size.width))\(Int(size.height))"
      if let value = imageCache[key] {
        imageRequested[key] = nil
        print("cached image returned: \(stringBigURL)")
        return value
      }
      else if let requested = imageRequested[key] where requested {
        print("image not back yet for: \(stringBigURL)")
        return nil
      }
      else {
        print("download requested: \(stringBigURL)")
        backgroundQueue.addOperationWithBlock { () -> Void in
          if let data = NSData(contentsOfURL: imageURL), image = UIImage(data: data) {
            // fastest way to resize an image; from nshipster.com
            // rounded corner method is my own; not sure of performance loss
            UIGraphicsBeginImageContext(size)
            let rect = CGRect(origin: CGPoint.zero, size: size)
            let inset = size.width/8
            image.drawInRect(rect)
            let path = UIBezierPath(roundedRect: CGRectInset(rect, -inset, -inset), cornerRadius: size.width/4)
            UIColor.whiteColor().setStroke()
            path.lineWidth = inset*2
            path.stroke()
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.imageCache[key] = resizedImage

            completionHandler(stringBigURL)
          }
        }
        imageRequested[key] = true
        print("background serial queue count: \(backgroundQueue.operationCount)")
        return nil
      }
    }
    return nil
  }
  func imageURLBiggerIsBetter(stringURL: String) -> NSURL? {
    let normalImageURL = NSURL(string: stringURL)
    var biggerImageURL = NSURL(string: stringURL)
    if let pathExtension = biggerImageURL?.pathExtension {
      biggerImageURL = biggerImageURL?.URLByDeletingPathExtension
      if let lastPathComponent = biggerImageURL?.lastPathComponent where lastPathComponent.hasSuffix(TwitterURLConsts.profileImageNormal) {
        biggerImageURL = biggerImageURL?.URLByDeletingLastPathComponent
        var pathComponent = lastPathComponent
        let range = pathComponent.endIndex.advancedBy(-TwitterURLConsts.profileImageNormal.characters.count)..<pathComponent.endIndex
        pathComponent.removeRange(range)
        pathComponent += TwitterURLConsts.profileImageBigger
        biggerImageURL = biggerImageURL?.URLByAppendingPathComponent(pathComponent)
        biggerImageURL = biggerImageURL?.URLByAppendingPathExtension(pathExtension)
        return biggerImageURL
      }
    }
    return normalImageURL
  }
}