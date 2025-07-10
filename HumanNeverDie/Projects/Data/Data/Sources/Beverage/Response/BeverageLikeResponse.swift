//
//  BeverageLikeResponse.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BeverageDomain

struct BeverageLikeResponse: Decodable {
  let productId: String?
  let liked: Bool?
  let likeCount: Int?
  
  init(
    productId: String?,
    liked: Bool?,
    likeCount: Int?
  ) {
    self.productId = productId
    self.liked = liked
    self.likeCount = likeCount
  }
}

extension BeverageLikeResponse {
  public func toDomain() -> BeverageLike {
    return .init(
      productID: productId ?? "",
      isLiked: liked ?? false,
      likeCount: likeCount ?? 0
    )
  }
}
