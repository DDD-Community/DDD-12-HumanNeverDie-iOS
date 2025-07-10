//
//  BeverageDetailResponse.swift
//  Data
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import BeverageDomain

struct BeverageDetailResponse: Decodable {
  let name: String?
  let productId: String?
  let imgUrl: String?
  let beverageType: String?
  let beverageNutrition: BeverageNutritionResponse?
  let cafeStoreDto: CafeStoreResponse?
  
  init(
    name: String?,
    productId: String?,
    imgUrl: String?,
    beverageType: String?,
    beverageNutrition: BeverageNutritionResponse?,
    cafeStoreDto: CafeStoreResponse?
  ) {
    self.name = name
    self.productId = productId
    self.imgUrl = imgUrl
    self.beverageType = beverageType
    self.beverageNutrition = beverageNutrition
    self.cafeStoreDto = cafeStoreDto
  }
}

struct BeverageNutritionResponse: Decodable {
  let servingKcal: Int?
  let saturatedFatG: Int?
  let proteinG: Int?
  let sodiumMg: Int?
  let sugarG: Int?
  let caffeineMg: Int?
  
  init(
    servingKcal: Int?,
    saturatedFatG: Int?,
    proteinG: Int?,
    sodiumMg: Int?,
    sugarG: Int?,
    caffeineMg: Int?
  ) {
    self.servingKcal = servingKcal
    self.saturatedFatG = saturatedFatG
    self.proteinG = proteinG
    self.sodiumMg = sodiumMg
    self.sugarG = sugarG
    self.caffeineMg = caffeineMg
  }
}

extension BeverageDetailResponse {
  public func toDomain() -> BeverageDetail {
    return .init(
      name: name ?? "",
      productID: productId ?? "",
      thumbnailURL: imgUrl ?? "",
      kcal: beverageNutrition?.servingKcal ?? 0,
      sugar: beverageNutrition?.sugarG ?? 0,
      saturatedFat: beverageNutrition?.saturatedFatG ?? 0,
      sodium: beverageNutrition?.sodiumMg ?? 0,
      caffeine: beverageNutrition?.caffeineMg ?? 0,
      brandName: cafeStoreDto?.cafeBrand ?? ""
    )
  }
}
