//
//  BeverageUseCase+Dependency.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import Dependencies

extension BeverageUseCase: TestDependencyKey {
  public static let testValue = BeverageUseCase()
}

public extension DependencyValues {
  var beverageUseCase: BeverageUseCase {
    get { self[BeverageUseCase.self] }
    set { self[BeverageUseCase.self] = newValue }
  }
}
