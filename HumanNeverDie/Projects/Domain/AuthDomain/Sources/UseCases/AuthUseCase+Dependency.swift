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
  func loginWithApple() async throws(AuthError) -> AuthUserInfo {
    print("Mock Login Success")
    return .init(userID: "", isFirstLogin: false)
  }
  
  func logout() async throws(AuthError) -> Bool { 
    print("Mock Logout Success")
    return true 
  }
  
  func withdraw() async throws(AuthError) -> Bool {
    return false
  }
  
  func hasValidAccessToken() -> Bool {
    // Mock에서는 false 반환 (미가입 상태 시뮬레이션)
    return false
  }
  
  func refreshToken() async throws(AuthError) -> Bool {
    print("Mock Refresh Token Success")
    return true
  }
}
