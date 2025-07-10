//
//  BeverageLike.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

public struct BeverageLike: Equatable {
  public let productID: String
  public let isLiked: Bool
  public let likeCount: Int
  
  public init(
    productID: String,
    isLiked: Bool,
    likeCount: Int
  ) {
    self.productID = productID
    self.isLiked = isLiked
    self.likeCount = likeCount
  }
}

extension BeverageLike {
  public static func mock() -> BeverageLike {
    return .init(
      productID: "starbucks_americano_001",
      isLiked: true,
      likeCount: 23
    )
  }
}
