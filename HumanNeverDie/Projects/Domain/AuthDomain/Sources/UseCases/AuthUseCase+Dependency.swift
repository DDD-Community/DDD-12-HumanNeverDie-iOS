//
//  AuthUseCase+Dependency.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Dependencies

public struct AuthUseCaseKey: TestDependencyKey {
  public static let testValue: AuthUseCaseProtocol = MockAuthUseCase()
}

public extension DependencyValues {
  var authUseCase: AuthUseCaseProtocol {
    get { self[AuthUseCaseKey.self] }
    set { self[AuthUseCaseKey.self] = newValue }
  }
}

// MARK: - MockAuthUseCase

private struct MockAuthUseCase: AuthUseCaseProtocol {
  func loginWithApple() async throws(AuthError) -> Bool {
    print("Mock Login Success")
    return true 
  }
  
  func logout() async throws(AuthError) -> Bool { 
    print("Mock Logout Success")
    return true 
  }
  
  func withdraw() async throws(AuthError) -> Bool {
    return false
  }
}
