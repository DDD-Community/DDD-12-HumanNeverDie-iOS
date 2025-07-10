//
//  BeverageUseCase+Dependency.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Dependencies

// MARK: - TestDependencyKey

public struct BeverageUseCaseKey: TestDependencyKey {
  public static let testValue: BeverageUseCaseProtocol = MockBeverageUseCase()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var beverageUseCase: BeverageUseCaseProtocol {
    get { self[BeverageUseCaseKey.self] }
    set { self[BeverageUseCaseKey.self] = newValue }
  }
}

// MARK: - MockMainRepository

private struct MockBeverageUseCase: BeverageUseCaseProtocol {
  func getBeverageCount() async throws -> BeverageCount { BeverageCount.mock() }
  func getBeverageList(cursor: String?) async throws -> BeverageList { BeverageList.mock() }
}
