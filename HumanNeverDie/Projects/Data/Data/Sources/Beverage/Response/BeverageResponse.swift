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
  let totalCount: Int?
  let zeroSugarCount: Int?
  let lowSugarCount: Int?
  
  init(
    items: [BeverageResponse],
    nextCursor: String?,
    hasNext: Bool?,
    likeCount: Int?,
    totalCount: Int? = nil,
    zeroSugarCount: Int? = nil,
    lowSugarCount: Int? = nil
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

extension BeverageListResponse {
  public func toDomain() -> BeverageList {
    return .init(
      items: items.map { $0.toDomain() },
      nextCursor: nextCursor,
      hasNext: hasNext ?? false,
      likeCount: likeCount ?? 0,
      totalCount: totalCount ?? 0,
      zeroSugarCount: zeroSugarCount ?? 0,
      lowSugarCount: lowSugarCount ?? 0
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
      brandType: BeverageBrandType(rawValue: cafeStoreDto?.cafeBrand ?? ""),
      sugarFreeType: BeverageSugarFreeType(sugar: Double(beverageNutrition?.sugarG ?? 0)),
      isLiked: isLiked ?? false
    )
  }
}
