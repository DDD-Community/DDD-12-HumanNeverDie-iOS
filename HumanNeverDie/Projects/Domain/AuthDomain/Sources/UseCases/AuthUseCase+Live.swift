//
//  AuthUseCase+Live.swift
//  AuthDomain
//

import Foundation

import Shared

import Dependencies

public extension AuthUseCase {
  static let live: AuthUseCase = .init(
    loginWithApple: { () async throws(AuthError) -> AuthUserInfo in
      @Dependency(\.authRepository) var authRepository
      @Dependency(\.keychainClient) var keychainClient
      
      let token = try await authRepository.loginWithApple()
      try await saveTokens(token, keychainClient: keychainClient)
      
      let userInfo = try await authRepository.getUserInfo()
      do {
        try await keychainClient.setValue(userInfo.userID, forKey: AMDKeychainKey.userID)
      } catch {
        throw AuthError.keychainError(error.localizedDescription)
      }
      
      return userInfo
    },
    logout: { () async throws(AuthError) -> Bool in
      @Dependency(\.authRepository) var authRepository
      @Dependency(\.keychainClient) var keychainClient
      
      try await clearKeychain(keychainClient)
      try await authRepository.logout()
      return true
    },
    withdraw: { () async throws(AuthError) -> Bool in
      @Dependency(\.authRepository) var authRepository
      @Dependency(\.keychainClient) var keychainClient
      
      try await authRepository.withdraw()
      try await clearKeychain(keychainClient)
      try await authRepository.logout()
      return true
    },
    hasValidAccessToken: {
      @Dependency(\.keychainClient) var keychainClient
      return keychainClient.getValue(forKey: AMDKeychainKey.accessToken) != nil
    },
    refreshToken: { () async throws(AuthError) -> Bool in
      @Dependency(\.authRepository) var authRepository
      @Dependency(\.keychainClient) var keychainClient
      
      let token = try await authRepository.refreshToken()
      try await saveTokens(token, keychainClient: keychainClient)
      return true
    }
  )
}

private func saveTokens(
  _ token: AuthToken,
  keychainClient: AMDKeychainClientProtocol
) async throws(AuthError) {
  do {
    try await keychainClient.setValue(token.accessToken, forKey: AMDKeychainKey.accessToken)
    if let refreshToken = token.refreshToken {
      try await keychainClient.setValue(refreshToken, forKey: AMDKeychainKey.refreshToken)
    }
    try await keychainClient.setValue(
      String(token.expiresIn.timeIntervalSince1970),
      forKey: AMDKeychainKey.expiresIn
    )
  } catch {
    throw AuthError.keychainError(error.localizedDescription)
  }
}

private func clearKeychain(_ keychainClient: AMDKeychainClientProtocol) async throws(AuthError) {
  do {
    try await keychainClient.removeAll()
  } catch {
    throw AuthError.keychainError(error.localizedDescription)
  }
}
