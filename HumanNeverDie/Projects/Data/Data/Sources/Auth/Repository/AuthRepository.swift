//
//  AuthRepository.swift
//  Data
//
//  Created by 김규철 on 8/20/25.
//

import Foundation

import AuthDomain
import BaseNetwork

import Dependencies

public final class AuthRepository: AuthRepositoryInterface, @unchecked Sendable {
  @Dependency(\.appleLoginManager) private var appleLoginManager
  
  public init() {}
  
  public func loginWithApple() async throws(AuthError) -> AuthToken {
    do {
      let appleAuthToken = try await appleLoginManager.loginWithApple()
      
      return AuthToken(
        accessToken: appleAuthToken.accessToken,
        refreshToken: appleAuthToken.refreshToken,
        idToken: appleAuthToken.idToken,
        expiresIn: appleAuthToken.expiresIn
      )
    } catch {
      switch error {
      case AppleLoginError.userCancelled:
        throw AuthError.userCancelled
      case AppleLoginError.authenticationFailed(let authError):
        throw AuthError.loginFailed(authError.localizedDescription)
      case AppleLoginError.credentialStoreFailed:
        throw AuthError.tokenStorageFailed
      case AppleLoginError.unknown(let unknownError):
        throw AuthError.unknown(unknownError.localizedDescription)
      }
    }
  }
  
  public func logout() async throws(AuthError) -> Void {
    do {
      try await appleLoginManager.logout()
    } catch {
      switch error {
      case AppleLoginError.authenticationFailed(let authError):
        throw AuthError.logoutFailed(authError.localizedDescription)
      case AppleLoginError.unknown(let unknownError):
        throw AuthError.unknown(unknownError.localizedDescription)
      default:
        throw AuthError.logoutFailed(error.localizedDescription)
      }
    }
  }
}
