//
//  AuthUseCase.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Foundation
import Dependencies

public protocol AuthUseCaseProtocol: Sendable {
  func loginWithApple() async throws(AuthError) -> Bool
  func logout() async throws(AuthError) -> Bool
}

public final class AuthUseCase: AuthUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.authRepository) private var authRepository
  
  public init() {}
  
  public func loginWithApple() async throws(AuthError) -> Bool {
    do {
      let token = try await authRepository.loginWithApple()
      print("Login Success - AuthToken: \(token)")
      return true
    } catch {
      throw error
    }
  }
  
  public func logout() async throws(AuthError) -> Bool {
    do {
      try await authRepository.logout()
      print("Logout Success")
      return true
    } catch {
      throw error
    }
  }
}
