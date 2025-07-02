//
//  Beverage.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/2/25.
//

import Foundation

public struct Beverage: Hashable {
  public let name: String
  public let productID: String
  public let thumbnailURL: String
  public let kcal: Int
  public let sugar: Int
  public let brandName: String
  public let sugarFreeType: BeverageSugarFreeType?
  public var isFavorite: Bool
  
  public init(
    name: String,
    productID: String,
    thumbnailURL: String,
    kcal: Int,
    sugar: Int,
    brandName: String,
    sugarFreeType: BeverageSugarFreeType?,
    isFavorite: Bool
  ) {
    self.name = name
    self.productID = productID
    self.thumbnailURL = thumbnailURL
    self.kcal = kcal
    self.sugar = sugar
    self.brandName = brandName
    self.sugarFreeType = sugarFreeType
    self.isFavorite = isFavorite
  }
}

public extension Beverage {
  static var mockData: [Beverage] {
    [
      Beverage(
        name: "아메리카노",
        productID: "starbucks_americano_001",
        thumbnailURL: "https://picsum.photos/200/300?random=15",
        kcal: 10,
        sugar: 0,
        brandName: "스타벅스",
        sugarFreeType: .zeroSugar,
        isFavorite: true
      ),
      Beverage(
        name: "카페라떼",
        productID: "starbucks_caffe_latte_001",
        thumbnailURL: "https://picsum.photos/200/300?random=42",
        kcal: 190,
        sugar: 14,
        brandName: "스타벅스",
        sugarFreeType: nil,
        isFavorite: false
      ),
      Beverage(
        name: "카라멜 마키아토",
        productID: "starbucks_caramel_macchiato_001",
        thumbnailURL: "https://picsum.photos/200/300?random=73",
        kcal: 240,
        sugar: 25,
        brandName: "스타벅스",
        sugarFreeType: nil,
        isFavorite: true
      ),
      Beverage(
        name: "바닐라 라떼",
        productID: "starbucks_vanilla_latte_001",
        thumbnailURL: "https://picsum.photos/200/300?random=128",
        kcal: 250,
        sugar: 35,
        brandName: "스타벅스",
        sugarFreeType: .lowSugar,
        isFavorite: false
      ),
      Beverage(
        name: "자바칩 프라푸치노",
        productID: "starbucks_java_chip_frappuccino_001",
        thumbnailURL: "https://picsum.photos/200/300?random=247",
        kcal: 440,
        sugar: 60,
        brandName: "스타벅스",
        sugarFreeType: nil,
        isFavorite: true
      ),
      Beverage(
        name: "콜드브루",
        productID: "starbucks_cold_brew_001",
        thumbnailURL: "https://picsum.photos/200/300?random=356",
        kcal: 5,
        sugar: 0,
        brandName: "스타벅스",
        sugarFreeType: nil,
        isFavorite: false
      ),
      Beverage(
        name: "돌체 라떼 (무설탕)",
        productID: "starbucks_dolce_latte_sugar_free_001",
        thumbnailURL: "https://picsum.photos/200/300?random=489",
        kcal: 150,
        sugar: 0,
        brandName: "스타벅스",
        sugarFreeType: .lowSugar,
        isFavorite: true
      ),
      Beverage(
        name: "그린티 라떼",
        productID: "starbucks_green_tea_latte_001",
        thumbnailURL: "https://picsum.photos/200/300?random=512",
        kcal: 270,
        sugar: 32,
        brandName: "스타벅스",
        sugarFreeType: nil,
        isFavorite: false
      ),
      Beverage(
        name: "아이스 블랙티",
        productID: "starbucks_iced_black_tea_001",
        thumbnailURL: "https://picsum.photos/200/300?random=677",
        kcal: 30,
        sugar: 8,
        brandName: "스타벅스",
        sugarFreeType: nil,
        isFavorite: false
      ),
      Beverage(
        name: "화이트 초콜릿 모카",
        productID: "starbucks_white_chocolate_mocha_001",
        thumbnailURL: "https://picsum.photos/200/300?random=894",
        kcal: 400,
        sugar: 53,
        brandName: "스타벅스",
        sugarFreeType: .lowSugar,
        isFavorite: true
      )
    ]
  }
  
  static var frequentMockData: [Beverage] {
    [.mockData[0], .mockData[1], .mockData[2]]
  }
}
