//
//  AuthRepositoryInterface+Dependency.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Dependencies

extension AuthRepositoryInterface: TestDependencyKey {
  public static var testValue: AuthRepositoryInterface {
    .init(
      loginWithApple: { () async throws(AuthError) -> AuthToken in
        throw AuthError.unknown("unimplemented: AuthRepositoryInterface.loginWithApple")
      },
      logout: { () async throws(AuthError) -> Void in
        throw AuthError.unknown("unimplemented: AuthRepositoryInterface.logout")
      },
      getUserInfo: { () async throws(AuthError) -> AuthUserInfo in
        throw AuthError.unknown("unimplemented: AuthRepositoryInterface.getUserInfo")
      },
      withdraw: { () async throws(AuthError) -> Void in
        throw AuthError.unknown("unimplemented: AuthRepositoryInterface.withdraw")
      },
      refreshToken: { () async throws(AuthError) -> AuthToken in
        throw AuthError.unknown("unimplemented: AuthRepositoryInterface.refreshToken")
      }
    )
  }
}

public extension DependencyValues {
  var authRepository: AuthRepositoryInterface {
    get { self[AuthRepositoryInterface.self] }
    set { self[AuthRepositoryInterface.self] = newValue }
  }
}
