//
//  BeverageResponse.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BeverageDomain

struct BeverageListResponse: Decodable {
  let brands: [BrandResponse]
  let nextCursor: String?
  let hasNext: Bool?
  let totalLikedCount: Int?

  init(
    brands: [BrandResponse],
    nextCursor: String?,
    hasNext: Bool?,
    totalLikedCount: Int?
  ) {
    self.brands = brands
    self.nextCursor = nextCursor
    self.hasNext = hasNext
    self.totalLikedCount = totalLikedCount
  }
}

struct BrandResponse: Decodable {
  let koreanBrandName: String?
  let items: [BeverageResponse]

  init(koreanBrandName: String?, items: [BeverageResponse]) {
    self.koreanBrandName = koreanBrandName
    self.items = items
  }
}

extension BeverageListResponse {
  public func toDomain() -> BeverageList {
    let allItems = brands.flatMap { brand -> [Beverage] in
      let brandName = brand.koreanBrandName ?? ""
      return brand.items.map { item in
        Beverage(
          name: item.name ?? "",
          productID: item.productId ?? "",
          thumbnailURL: item.imgUrl ?? "",
          kcal: item.beverageNutrition?.servingKcal ?? 0,
          sugar: item.beverageNutrition?.sugarG ?? 0,
          koreanBrandName: brandName,
          sugarFreeType: BeverageSugarFreeType(sugar: Double(item.beverageNutrition?.sugarG ?? 0)),
          isLiked: item.isLiked ?? false
        )
      }
    }
    return .init(
      items: allItems,
      nextCursor: nextCursor,
      hasNext: hasNext ?? false,
      likeCount: totalLikedCount ?? 0
    )
  }
}

struct BeverageResponse: Decodable {
  let productId: String?
  let name: String?
  let imgUrl: String?
  let beverageType: String?
  let beverageNutrition: BeverageNutritionResponse?
  let isLiked: Bool?

  init(
    productId: String?,
    name: String?,
    imgUrl: String?,
    beverageType: String?,
    beverageNutrition: BeverageNutritionResponse?,
    isLiked: Bool?
  ) {
    self.productId = productId
    self.name = name
    self.imgUrl = imgUrl
    self.beverageType = beverageType
    self.beverageNutrition = beverageNutrition
    self.isLiked = isLiked
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
      koreanBrandName: "",
      sugarFreeType: BeverageSugarFreeType(sugar: Double(beverageNutrition?.sugarG ?? 0)),
      isLiked: isLiked ?? false
    )
  }
}
