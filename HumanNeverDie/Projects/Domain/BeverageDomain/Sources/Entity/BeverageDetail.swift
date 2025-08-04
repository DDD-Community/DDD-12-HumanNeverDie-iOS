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
  public let kcal: Int
  public let sugar: Int
  public let protein: Int
  public let saturatedFat: Int
  public let sodium: Int
  public let caffeine: Int
  public let brandName: String
  
  public init(
    name: String,
    productID: String,
    thumbnailURL: String,
    kcal: Int,
    sugar: Int,
    protein: Int,
    saturatedFat: Int,
    sodium: Int,
    caffeine: Int,
    brandName: String
  ) {
    self.name = name
    self.productID = productID
    self.thumbnailURL = thumbnailURL
    self.kcal = kcal
    self.sugar = sugar
    self.protein = protein
    self.saturatedFat = saturatedFat
    self.sodium = sodium
    self.caffeine = caffeine
    self.brandName = brandName
  }
}

extension BeverageDetail {
  public func toBeverage(isLiked: Bool) -> Beverage {
    return .init(
      name: name,
      productID: productID,
      thumbnailURL: thumbnailURL,
      kcal: kcal,
      sugar: sugar,
      brandName: brandName,
      sugarFreeType: BeverageSugarFreeType(sugar: sugar),
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
      kcal: 10,
      sugar: 20,
      protein: 10,
      saturatedFat: 10,
      sodium: 130,
      caffeine: 140,
      brandName: "스타벅스"
    )
  }
}
