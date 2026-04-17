//
//  AuthUseCase+Dependency.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Dependencies

extension AuthUseCase: TestDependencyKey {
  public static var testValue: AuthUseCase {
    .init(
      loginWithApple: { () async throws(AuthError) -> AuthUserInfo in
        throw AuthError.unknown("unimplemented: AuthUseCase.loginWithApple")
      },
      logout: { () async throws(AuthError) -> Bool in
        throw AuthError.unknown("unimplemented: AuthUseCase.logout")
      },
      withdraw: { () async throws(AuthError) -> Bool in
        throw AuthError.unknown("unimplemented: AuthUseCase.withdraw")
      },
      hasValidAccessToken: { false },
      refreshToken: { () async throws(AuthError) -> Bool in
        throw AuthError.unknown("unimplemented: AuthUseCase.refreshToken")
      }
    )
  }
}

public extension DependencyValues {
  var authUseCase: AuthUseCase {
    get { self[AuthUseCase.self] }
    set { self[AuthUseCase.self] = newValue }
  }
}
