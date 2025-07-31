//
//  AMDLocalDataBaseService+Dependency.swift
//  LocalDataBase
//
//  Created by 김규철 on 7/31/25.
//

import Foundation

import Dependencies

// MARK: - TestDependencyKey

public struct AMDLocalDataBaseServiceKey: TestDependencyKey {
  public static var testValue: AMDLocalDataBaseServiceProtocol {
    fatalError("\(AMDLocalDataBaseServiceProtocol.self) Implementation not available")
  }
}

// MARK: - DependencyValues

public extension DependencyValues {
  var localDataBaseService: AMDLocalDataBaseServiceProtocol {
    get { self[AMDLocalDataBaseServiceKey.self] }
    set { self[AMDLocalDataBaseServiceKey.self] = newValue }
  }
}
