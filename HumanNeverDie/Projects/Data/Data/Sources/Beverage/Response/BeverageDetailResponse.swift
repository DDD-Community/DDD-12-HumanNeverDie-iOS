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

extension BeverageDetailResponse {
  public func toDomain() -> BeverageDetail {
    let defaultBeverageNutrition = BeverageNutrition(
      kcal: 0,
      sugar: 0,
      protein: 0,
      saturatedFat: 0,
      sodium: 0,
      caffeine: 0
    )
    
    let domainNutrition = defaultNutrition?.toDomain() ?? defaultBeverageNutrition
    let domainSizes = sizes?.map { $0.toDomain() }.sorted { $0.nutrition.kcal < $1.nutrition.kcal } ?? []
    
    return BeverageDetail(
      name: name ?? "",
      productID: productId ?? "",
      thumbnailURL: imgUrl ?? "",
      defaultNutrition: domainNutrition,
      sizes: domainSizes,
      brandType: BeverageBrandType(rawValue: cafeStoreDto?.cafeBrand ?? "")
    )
  }
}

struct BeverageDetailSizeResponse: Decodable {
  let sizeType: String?
  let nutrition: BeverageNutritionResponse?
  
  init(
    sizeType: String?,
    nutrition: BeverageNutritionResponse?
  ) {
    self.sizeType = sizeType
    self.nutrition = nutrition
  }
}

extension BeverageDetailSizeResponse {
  func toDomain() -> BeverageSize {
    return BeverageSize(
      sizeType: (sizeType ?? "").capitalized,
      nutrition: nutrition?.toDomain() ?? BeverageNutrition(kcal: 0, sugar: 0, protein: 0, saturatedFat: 0, sodium: 0, caffeine: 0)
    )
  }
}
