//
//  UserUseCase+Dependency.swift
//  UserDomain
//
//  Created by Seulki Lee on 8/14/25.
//

import Foundation
import Dependencies

extension UserUseCase: TestDependencyKey {
  public static let testValue = UserUseCase()
}

public extension DependencyValues {
  var userUseCase: UserUseCase {
    get { self[UserUseCase.self] }
    set { self[UserUseCase.self] = newValue }
  }
}
