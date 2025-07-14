//
//  BeverageCount.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

public struct BeverageCount: Equatable, Sendable {
  public let totalCount: Int
  public let zeroCount: Int
  public let lowCount: Int
  
  public init(
    totalCount: Int,
    zeroCount: Int,
    lowCount: Int
  ) {
    self.totalCount = totalCount
    self.zeroCount = zeroCount
    self.lowCount = lowCount
  }
}

extension BeverageCount {
  static func mock() -> BeverageCount {
    return .init(
      totalCount: 0,
      zeroCount: 0,
      lowCount: 0
    )
  }
}
