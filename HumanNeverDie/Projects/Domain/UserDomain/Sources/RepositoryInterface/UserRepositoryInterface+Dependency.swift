//
//  UserRepositoryInterface+Dependency.swift
//  UserDomain
//
//  Created by Seulki Lee on 8/12/25.
//

import Foundation

import Dependencies

extension UserRepositoryInterface: TestDependencyKey {
  public static let testValue = UserRepositoryInterface()
}

public extension DependencyValues {
  var userRepository: UserRepositoryInterface {
    get { self[UserRepositoryInterface.self] }
    set { self[UserRepositoryInterface.self] = newValue }
  }
}
