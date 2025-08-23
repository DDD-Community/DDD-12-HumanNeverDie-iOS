//
//  AppleAuthToken.swift
//  BaseNetwork
//
//  Created by Claude on 8/20/25.
//

import Foundation

import Alamofire

public struct AppleAuthToken: Sendable {
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

// MARK: - AuthenticationCredential

extension AppleAuthToken: AuthenticationCredential {
  public var requiresRefresh: Bool {
    // 5분 이내 만료 시 갱신 필요
    Date(timeIntervalSinceNow: 60 * 5) > expiresIn
  }
}
