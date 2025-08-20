//
//  AuthToken.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Foundation

public struct AuthToken: Sendable, Equatable {
  public let accessToken: String
  public let refreshToken: String?
  public let idToken: String
  public let expiresIn: Date
  
  public init(
    accessToken: String,
    refreshToken: String?,
    idToken: String,
    expiresIn: Date
  ) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.idToken = idToken
    self.expiresIn = expiresIn
  }
}

extension AuthToken {
  public var isExpired: Bool {
    Date() >= expiresIn
  }
  
  public var isExpiringSoon: Bool {
    Date().addingTimeInterval(300) >= expiresIn
  }
}