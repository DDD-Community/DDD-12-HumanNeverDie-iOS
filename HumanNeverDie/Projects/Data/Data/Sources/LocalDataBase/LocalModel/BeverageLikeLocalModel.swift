import Foundation
import SwiftData

import BeverageDomain

@Model
final class BeverageLikeLocalModel: @unchecked Sendable {
  var productID: String
  var isLiked: Bool           // 현재 상태
  var originalIsLiked: Bool   // 서버에서 받은 초기 상태
  var createdAt: Date
  
  init(
    productID: String,
    isLiked: Bool,
    originalIsLiked: Bool,
    createdAt: Date = Date()
  ) {
    self.productID = productID
    self.isLiked = isLiked
    self.originalIsLiked = originalIsLiked
    self.createdAt = createdAt
  }
}

extension BeverageLikeLocalModel {
  public func toDomain() -> BeverageLike {
    return .init(
      productID: productID,
      isLiked: isLiked,
      likeCount: 0
    )
  }
}
