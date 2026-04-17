//
//  BeverageLikeLocalRepositoryInterface+Dependency.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/31/25.
//

import Dependencies

extension BeverageLikeLocalRepositoryInterface: TestDependencyKey {
  public static let testValue = BeverageLikeLocalRepositoryInterface(
    fetchAllBeverageLike: { unimplemented("BeverageLikeLocalRepositoryInterface.fetchAllBeverageLike", placeholder: []) },
    fetchBeverageLikeCount: { unimplemented("BeverageLikeLocalRepositoryInterface.fetchBeverageLikeCount", placeholder: 0) },
    fetchBeverageLike: { _ in unimplemented("BeverageLikeLocalRepositoryInterface.fetchBeverageLike", placeholder: nil) },
    saveBeverageLike: { _, _ in reportIssue("BeverageLikeLocalRepositoryInterface.saveBeverageLike is unimplemented") },
    removeBeverageLike: { _ in reportIssue("BeverageLikeLocalRepositoryInterface.removeBeverageLike is unimplemented") }
  )
}

public extension DependencyValues {
  var beverageLikeLocalRepository: BeverageLikeLocalRepositoryInterface {
    get { self[BeverageLikeLocalRepositoryInterface.self] }
    set { self[BeverageLikeLocalRepositoryInterface.self] = newValue }
  }
}
