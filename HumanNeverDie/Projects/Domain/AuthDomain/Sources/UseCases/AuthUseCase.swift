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
  func loginWithApple() async throws(AuthError) -> AuthUserInfo
  func logout() async throws(AuthError) -> Bool
  func withdraw() async throws(AuthError) -> Bool
  func hasValidAccessToken() -> Bool
  func refreshToken() async throws(AuthError) -> Bool
}

public final class AuthUseCase: AuthUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.authRepository) private var authRepository
  @Dependency(\.keychainClient) private var keychainClient
  
  public init() {}
  
  public func loginWithApple() async throws(AuthError) -> AuthUserInfo {
    do {
      let token = try await authRepository.loginWithApple()
      try await saveTokensToKeychain(token)
      
      let userInfo = try await getUserInfo()
      try await saveUserIDToKeychain(userInfo.userID)
      
      return userInfo
    } catch {
      throw error
    }
  }
  
  public func logout() async throws(AuthError) -> Bool {
    do {
      try await clearKeychain()
      try await authRepository.logout()
      return true
    } catch {
      throw error
    }
  }
  
  public func withdraw() async throws(AuthError) -> Bool {
    do {
      try await authRepository.withdraw()
      try await clearKeychain()
      try await authRepository.logout()
      return true
    } catch {
      throw error
    }
  }
  
  public func hasValidAccessToken() -> Bool {
    return keychainClient.getValue(forKey: AMDKeychainKey.accessToken) != nil
  }
  
  public func refreshToken() async throws(AuthError) -> Bool {
    do {
      let token = try await authRepository.refreshToken()
      try await saveTokensToKeychain(token)
      
      return true
    } catch {
      throw error
    }
  }
}

// MARK: - Private Methods

private extension AuthUseCase {
  func getUserInfo() async throws(AuthError) -> AuthUserInfo {
    do {
      let userInfo = try await authRepository.getUserInfo()
      return userInfo
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
      
      try await keychainClient.setValue(String(token.expiresIn.timeIntervalSince1970), forKey: AMDKeychainKey.expiresIn)
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
  
  func clearKeychain() async throws(AuthError) {
    do {
      try await keychainClient.removeAll()
    } catch {
      throw AuthError.keychainError(error.localizedDescription)
    }
  }
}
