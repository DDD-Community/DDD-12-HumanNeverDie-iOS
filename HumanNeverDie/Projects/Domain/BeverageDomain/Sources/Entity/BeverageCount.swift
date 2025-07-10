//
//  BeverageCount.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

public struct BeverageCount: Equatable {
  public let totalCount: String
  public let zeroCount: String
  public let lowCount: String
  
  public init(
    totalCount: String,
    zeroCount: String,
    lowCount: String
  ) {
    self.totalCount = totalCount
    self.zeroCount = zeroCount
    self.lowCount = lowCount
  }
}

extension BeverageCount {
  static func mock() -> BeverageCount {
    return .init(
      totalCount: "0",
      zeroCount: "0",
      lowCount: "0"
    )
  }
}
