//
//  AuthRepositoryInterface+Dependency.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import Dependencies

public struct AuthRepositoryInterfaceKey: TestDependencyKey {
  public static var testValue: AuthRepositoryInterface {
    fatalError("\(AuthRepositoryInterface.self) Implementation not available")
  }
}

extension DependencyValues {
  var authRepository: AuthRepositoryInterface {
    get { self[AuthRepositoryInterfaceKey.self] }
    set { self[AuthRepositoryInterfaceKey.self] = newValue }
  }
}
