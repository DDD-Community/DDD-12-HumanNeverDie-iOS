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

  public init(
    items: [Beverage],
    nextCursor: String?,
    hasNext: Bool,
    likeCount: Int
  ) {
    self.items = items
    self.nextCursor = nextCursor
    self.hasNext = hasNext
    self.likeCount = likeCount
  }
}

extension BeverageList {
  public static func mock() -> BeverageList {
    .init(
      items: Beverage.mockData,
      nextCursor: nil,
      hasNext: false,
      likeCount: 0
    )
  }
}
