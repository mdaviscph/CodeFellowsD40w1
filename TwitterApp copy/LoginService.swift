//
//  LoginService.swift
//  TwitterApp
//
//  Created by mike davis on 8/4/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation
import Accounts

class LoginService {
  class func loginForTwitter(completionHandler: (String?, ACAccount?) -> Void) {
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
      if let error = error {
        completionHandler(ErrorMessageConsts.notSignedIn, nil)
      } else {
        if granted {
          if let account = accountStore.accountsWithAccountType(accountType).first as? ACAccount {
            completionHandler(nil, account)
          } else {
            completionHandler(ErrorMessageConsts.noTwitterAccount, nil)
          }
        }
        else {
          completionHandler(ErrorMessageConsts.noAccess, nil)
        }
      }
    }
  }
}