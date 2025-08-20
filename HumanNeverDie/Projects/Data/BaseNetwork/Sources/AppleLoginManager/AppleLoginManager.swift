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
  func loginWithApple() async throws(AppleLoginError) -> Credentials
  func logout() async throws(AppleLoginError) -> Void
}

public actor AppleLoginManager: AppleLoginManagerProtocol {
  public init() {}
  
  public func loginWithApple() async throws(AppleLoginError) -> Credentials {
    do {
      let credentials = try await Auth0
        .webAuth()
        .connection("apple")
        .useHTTPS()
        .start()
      
      return credentials
      
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
