//
//  BeverageRepositoryInterface+Dependency.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import Dependencies

extension BeverageRepositoryInterface: TestDependencyKey {
  public static let testValue = BeverageRepositoryInterface()
}

public extension DependencyValues {
  var beverageRepository: BeverageRepositoryInterface {
    get { self[BeverageRepositoryInterface.self] }
    set { self[BeverageRepositoryInterface.self] = newValue }
  }
}
