//
//  BeverageLikeLocalRepositoryInterface.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/31/25.
//

import Foundation

import DependenciesMacros

@DependencyClient
public struct BeverageLikeLocalRepositoryInterface: Sendable {
  public var fetchAllBeverageLike: @Sendable () throws -> [BeverageLike]
  public var fetchBeverageLikeCount: @Sendable () throws -> Int
  public var fetchBeverageLike: @Sendable (_ productID: String) throws -> BeverageLike?
  public var saveBeverageLike: @Sendable (_ beverage: Beverage, _ originalIsLiked: Bool) throws -> Void
  public var removeBeverageLike: @Sendable (_ productID: String) throws -> Void
}
