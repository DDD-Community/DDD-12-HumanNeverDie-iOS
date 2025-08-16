//
//  BeverageList.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

public struct BeverageList: Equatable, Sendable {
  public let items: [Beverage]
  public let nextCursor: String?
  public let hasNext: Bool
  public var likeCount: Int
  public let totalCount: Int
  public let zeroSugarCount: Int
  public let lowSugarCount: Int
  
  public init(
    items: [Beverage],
    nextCursor: String?,
    hasNext: Bool,
    likeCount: Int,
    totalCount: Int = 0,
    zeroSugarCount: Int = 0,
    lowSugarCount: Int = 0
  ) {
    self.items = items
    self.nextCursor = nextCursor
    self.hasNext = hasNext
    self.likeCount = likeCount
    self.totalCount = totalCount
    self.zeroSugarCount = zeroSugarCount
    self.lowSugarCount = lowSugarCount
  }
}

extension BeverageList {
  public static func mock() -> BeverageList {
    .init(
      items: Beverage.mockData,
      nextCursor: nil,
      hasNext: false,
      likeCount: 0,
      totalCount: 0,
      zeroSugarCount: 0,
      lowSugarCount: 0
    )
  }
}
