//
//  BeverageLikeLocalRepositoryInterface+Dependency.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/31/25.
//

import Dependencies

// MARK: - TestDependencyKey

public struct BeverageLikeLocalRepositoryKey: TestDependencyKey {
  public static let testValue: BeverageLikeLocalRepositoryInterface = MockBeverageLikeLocalRepository()
}

// MARK: - DependencyValues

extension DependencyValues {
  var beverageLikeLocalRepository: BeverageLikeLocalRepositoryInterface {
    get { self[BeverageLikeLocalRepositoryKey.self] }
    set { self[BeverageLikeLocalRepositoryKey.self] = newValue }
  }
}

// MARK: - MockBeverageLikeLocalRepository

private struct MockBeverageLikeLocalRepository: BeverageLikeLocalRepositoryInterface {
  func fetchAllBeverageLike() throws -> [BeverageLike] { return [] }
  func fetchBeverageLikeCount() throws -> Int { return 0 }
  func fetchBeverageLike(productID: String) throws -> BeverageLike? { return nil }
  func saveBeverageLike(beverage: Beverage, originalIsLiked: Bool) throws {}
  func removeBeverageLike(productID: String) throws {}
}
