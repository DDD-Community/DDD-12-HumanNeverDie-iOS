//
//  BeverageRepositoryInterface.swift
//  BeverageDomain
//
//  Created by 김규철 on 2025/07/02.
//

import Foundation

public protocol BeverageRepositoryInterface {
  func getBeverageCount() async throws -> BeverageCount
  func getBeverageList(cursor: String?) async throws -> BeverageList
  func getBeverageDetail(productID: String) async throws -> BeverageDetail
  func likeBeverage(productID: String) async throws -> BeverageLike
  func unLikeBeverage(productID: String) async throws -> BeverageLike
}
