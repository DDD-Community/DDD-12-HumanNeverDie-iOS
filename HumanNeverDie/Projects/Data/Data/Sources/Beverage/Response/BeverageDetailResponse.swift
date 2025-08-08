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
  let defaultNutrition: BeverageNutritionResponse?
  let sizes: [BeverageDetailSizeResponse]?
  let cafeStoreDto: CafeStoreResponse?
  
  init(
    name: String?,
    productId: String?,
    imgUrl: String?,
    beverageType: String?,
    defaultNutrition: BeverageNutritionResponse?,
    sizes: [BeverageDetailSizeResponse]?,
    cafeStoreDto: CafeStoreResponse?
  ) {
    self.name = name
    self.productId = productId
    self.imgUrl = imgUrl
    self.beverageType = beverageType
    self.defaultNutrition = defaultNutrition
    self.sizes = sizes
    self.cafeStoreDto = cafeStoreDto
  }
}

struct BeverageDetailSizeResponse: Decodable {
  let sizeType: String
  let nutrition: BeverageNutritionResponse
  
  init(
    sizeType: String,
    nutrition: BeverageNutritionResponse
  ) {
    self.sizeType = sizeType
    self.nutrition = nutrition
  }
}

extension BeverageDetailResponse {
  public func toDomain() -> BeverageDetail {
    return .init(
      name: name ?? "",
      productID: productId ?? "",
      thumbnailURL: imgUrl ?? "",
      defaultNutrition: defaultNutrition?.toDomain() ?? BeverageNutrition(kcal: 0, sugar: 0, protein: 0, saturatedFat: 0, sodium: 0, caffeine: 0),
      sizes: sizes?.map { $0.toDomain() } ?? [],
      brandName: cafeStoreDto?.cafeBrand ?? ""
    )
  }
}

extension BeverageNutritionResponse {
  func toDomain() -> BeverageNutrition {
    return BeverageNutrition(
      kcal: servingKcal ?? 0,
      sugar: sugarG ?? 0,
      protein: proteinG ?? 0,
      saturatedFat: Int(saturatedFatG ?? 0),
      sodium: sodiumMg ?? 0,
      caffeine: caffeineMg ?? 0
    )
  }
}

extension BeverageDetailSizeResponse {
  func toDomain() -> BeverageSize {
    return BeverageSize(
      sizeType: sizeType,
      nutrition: nutrition.toDomain()
    )
  }
}
