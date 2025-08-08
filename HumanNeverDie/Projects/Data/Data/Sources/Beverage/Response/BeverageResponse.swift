//
//  BeverageResponse.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BeverageDomain

struct BeverageListResponse: Decodable {
  let items: [BeverageResponse]
  let nextCursor: String?
  let hasNext: Bool?
  let likeCount: Int?
  
  init(
    items: [BeverageResponse],
    nextCursor: String?,
    hasNext: Bool?,
    likeCount: Int?
  ) {
    self.items = items
    self.nextCursor = nextCursor
    self.hasNext = hasNext
    self.likeCount = likeCount
  }
}

extension BeverageListResponse {
  public func toDomain() -> BeverageList {
    return .init(
      items: items.map { $0.toDomain() },
      nextCursor: nextCursor,
      hasNext: hasNext ?? false,
      likeCount: likeCount ?? 0
    )
  }
}

struct BeverageResponse: Decodable {
  let productId: String?
  let name: String?
  let imgUrl: String?
  let beverageType: String?
  let beverageNutrition: BeverageNutritionResponse?
  let cafeStoreDto: CafeStoreResponse?
  let isLiked: Bool?
  
  init(
    productId: String?,
    name: String?,
    imgUrl: String?,
    beverageType: String?,
    beverageNutrition: BeverageNutritionResponse?,
    cafeStoreDto: CafeStoreResponse?,
    isLiked: Bool?
  ) {
    self.productId = productId
    self.name = name
    self.imgUrl = imgUrl
    self.beverageType = beverageType
    self.beverageNutrition = beverageNutrition
    self.cafeStoreDto = cafeStoreDto
    self.isLiked = isLiked
  }
}

struct CafeStoreResponse: Decodable {
  let cafeBrand: String?
  
  init(cafeBrand: String?) {
    self.cafeBrand = cafeBrand
  }
}

extension BeverageResponse {
  public func toDomain() -> Beverage {
    return .init(
      name: name ?? "",
      productID: productId ?? "",
      thumbnailURL: imgUrl ?? "",
      kcal: beverageNutrition?.servingKcal ?? 0,
      sugar: beverageNutrition?.sugarG ?? 0,
      brandName: cafeStoreDto?.cafeBrand ?? "",
      sugarFreeType: BeverageSugarFreeType(sugar: beverageNutrition?.sugarG ?? 0),
      isLiked: isLiked ?? false
    )
  }
}
