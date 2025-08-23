//
//  AuthRepositoryInterface.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Foundation

public protocol AuthRepositoryInterface: Sendable {
  func loginWithApple() async throws(AuthError) -> AuthToken
  func logout() async throws(AuthError) -> Void
  func getUserInfo() async throws(AuthError) -> AuthUserInfo
  func withdraw() async throws(AuthError) -> Void
  func refreshToken() async throws(AuthError) -> AuthToken
}
