//
//  BeverageLikeLocalRepositoryInterface.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/31/25.
//

import Foundation

public protocol BeverageLikeLocalRepositoryInterface: Sendable {
  func fetchAllBeverageLike() throws -> [BeverageLike]
  func fetchBeverageLikeCount() throws -> Int
  func fetchBeverageLike(productID: String) throws -> BeverageLike?
  func saveBeverageLike(beverage: Beverage, originalIsLiked: Bool) throws
  func removeBeverageLike(productID: String) throws
}
