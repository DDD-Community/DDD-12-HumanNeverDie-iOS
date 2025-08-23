//
//  AuthUserInfo.swift
//  AuthDomain
//
//  Created by Claude on 8/22/25.
//

import Foundation

public struct AuthUserInfo: Sendable {
  public let userID: String
  public let isFirstLogin: Bool
  
  public init(userID: String, isFirstLogin: Bool) {
    self.userID = userID
    self.isFirstLogin = isFirstLogin
  }
}
