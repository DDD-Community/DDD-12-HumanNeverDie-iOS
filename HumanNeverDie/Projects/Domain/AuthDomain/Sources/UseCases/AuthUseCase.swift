//
//  AuthUseCase.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Foundation

import Shared

import Dependencies

public protocol AuthUseCaseProtocol: Sendable {
  func loginWithApple() async throws(AuthError) -> Bool
  func logout() async throws(AuthError) -> Bool
}

public final class AuthUseCase: AuthUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.authRepository) private var authRepository
  @Dependency(\.keychainClient) private var keychainClient
  
  public init() {}
  
  public func loginWithApple() async throws(AuthError) -> Bool {
    do {
      let token = try await authRepository.loginWithApple()
      try await saveTokensToKeychain(token)
            
      let userID = try await getUserID(accessToken: token.accessToken)
      try await saveUserIDToKeychain(userID)

      return true
    } catch {
      throw error
    }
  }
  
  public func logout() async throws(AuthError) -> Bool {
    do {
      try await authRepository.logout()
      return true
    } catch {
      throw error
    }
  }
}

// MARK: - Private Methods

private extension AuthUseCase {
  func getUserID(accessToken: String) async throws(AuthError) -> String {
    do {
      let userID = try await authRepository.validateToken(accessToken: accessToken)
      return userID
    } catch {
      throw error
    }
  }
  
  func saveTokensToKeychain(_ token: AuthToken) async throws(AuthError) {
    do {
      try await keychainClient.setValue(token.accessToken, forKey: AMDKeychainKey.accessToken)
      
      if let refreshToken = token.refreshToken {
        try await keychainClient.setValue(refreshToken, forKey: AMDKeychainKey.refreshToken)
      }
    } catch {
      throw AuthError.keychainError(error.localizedDescription)
    }
  }
  
  func saveUserIDToKeychain(_ userID: String) async throws(AuthError) {
    do {
      try await keychainClient.setValue(userID, forKey: AMDKeychainKey.userID)
    } catch {
      throw AuthError.keychainError(error.localizedDescription)
    }
  }
}
