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
  func validateToken(accessToken: String) async throws(AuthError) -> String
}
