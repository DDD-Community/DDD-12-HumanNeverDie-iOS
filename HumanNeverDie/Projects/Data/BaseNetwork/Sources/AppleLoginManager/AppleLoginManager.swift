//
//  AppleLoginManager.swift
//  BaseNetwork
//
//  Created by Claude on 8/20/25.
//

import Foundation

import Auth0
import Dependencies

public protocol AppleLoginManagerProtocol: Sendable {
  func loginWithApple() async throws(AppleLoginError) -> AppleAuthToken
  func logout() async throws(AppleLoginError) -> Void
}

public actor AppleLoginManager: AppleLoginManagerProtocol {
  private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
  public init() {}
  
  public func loginWithApple() async throws(AppleLoginError) -> AppleAuthToken {
    do {
      let credentials = try await Auth0
        .webAuth()
        .connection("apple")
        .useHTTPS()
        .start()
      
      let success = credentialsManager.store(credentials: credentials)
      guard success else {
        throw AppleLoginError.credentialStoreFailed
      }
      
      return AppleAuthToken(
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
        idToken: credentials.idToken,
        expiresIn: credentials.expiresIn
      )
      
    } catch let error as WebAuthError {
      switch error {
      case .userCancelled:
        throw AppleLoginError.userCancelled
      default:
        throw AppleLoginError.authenticationFailed(error)
      }
    } catch {
      throw AppleLoginError.unknown(error)
    }
  }
  
  public func logout() async throws(AppleLoginError) -> Void {
    do {
      try await Auth0
        .webAuth()
        .clearSession()
      
    } catch {
      throw AppleLoginError.authenticationFailed(error)
    }
  }
}

// MARK: - TestDependencyKey

public struct AppleLoginManagerKey: TestDependencyKey {
  public static var testValue: AppleLoginManagerProtocol {
    fatalError("\(AppleLoginManagerProtocol.self) Implementation not available")
  }
}

// MARK: - DependencyValues

public extension DependencyValues {
  var appleLoginManager: AppleLoginManagerProtocol {
    get { self[AppleLoginManagerKey.self] }
    set { self[AppleLoginManagerKey.self] = newValue }
  } 
}
