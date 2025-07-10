//
//  BeverageCountResponse.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BeverageDomain

struct BeverageCountResponse: Decodable {
  let totalCount: Int
  let zeroCount: Int
  let lowCount: Int
  
  init(
    totalCount: Int,
    zeroCount: Int,
    lowCount: Int
  ) {
    self.totalCount = totalCount
    self.zeroCount = zeroCount
    self.lowCount = lowCount
  }
}

extension BeverageCountResponse {
  public func toDomain() -> BeverageCount {
    return .init(
      totalCount: String(totalCount),
      zeroCount: String(zeroCount),
      lowCount: String(lowCount)
    )
  }
}
