//
//  BeverageRepositoryInterface+Dependency.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Dependencies

// MARK: - TestDependencyKey

public struct BeverageRepositoryKey: TestDependencyKey {
  public static let testValue: BeverageRepositoryInterface = MockBeverageRepository()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var beverageRepository: BeverageRepositoryInterface {
    get { self[BeverageRepositoryKey.self] }
    set { self[BeverageRepositoryKey.self] = newValue }
  }
}

// MARK: - MockMainRepository

private struct MockBeverageRepository: BeverageRepositoryInterface {
  func getBeverageCount() async throws -> BeverageCount { BeverageCount.mock() }
  func getBeverageList(cursor: String?) async throws -> BeverageList { BeverageList.mock() }
  func getBeverageDetail(productID: String) async throws -> BeverageDetail { BeverageDetail.mock() }
  func likeBeverage(productID: String) async throws -> BeverageLike { BeverageLike.mock() }
  func unLikeBeverage(productID: String) async throws -> BeverageLike { BeverageLike.mock() }
  func searchBeverage(keyword: String) async throws -> BeverageList { BeverageList.mock() }
}
