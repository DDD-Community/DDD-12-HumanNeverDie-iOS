//
//  BeverageDetail.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

public struct BeverageDetail: Equatable, Sendable {
  public let name: String
  public let productID: String
  public let thumbnailURL: String
  public let defaultNutrition: BeverageNutrition
  public let sizes: [BeverageSize]
  public let brandType: String?

  public init(
    name: String,
    productID: String,
    thumbnailURL: String,
    defaultNutrition: BeverageNutrition,
    sizes: [BeverageSize],
    brandType: String?
  ) {
    self.name = name
    self.productID = productID
    self.thumbnailURL = thumbnailURL
    self.defaultNutrition = defaultNutrition
    self.sizes = sizes
    self.brandType = brandType
  }
}

extension BeverageDetail {
  public func toBeverage(isLiked: Bool) -> Beverage {
    return .init(
      name: name,
      productID: productID,
      thumbnailURL: thumbnailURL,
      kcal: defaultNutrition.kcal,
      sugar: defaultNutrition.sugar,
      brandType: brandType,
      sugarFreeType: BeverageSugarFreeType(sugar: Double(defaultNutrition.sugar)),
      isLiked: isLiked
    )
  }
}

extension BeverageDetail {
  public static func mock() -> BeverageDetail {
    .init(
      name: "아메리카노",
      productID: "starbucks_americano_001",
      thumbnailURL: "https://picsum.photos/200/300?random=15",
      defaultNutrition: BeverageNutrition(
        kcal: 10,
        sugar: 20,
        protein: 10,
        saturatedFat: 10,
        sodium: 130,
        caffeine: 140
      ),
      sizes: [
        BeverageSize(
          sizeType: "TALL",
          nutrition: BeverageNutrition(
            kcal: 10,
            sugar: 20,
            protein: 10,
            saturatedFat: 10,
            sodium: 130,
            caffeine: 140
          )
        )
      ],
      brandType: "STARBUCKS"
    )
  }
}
