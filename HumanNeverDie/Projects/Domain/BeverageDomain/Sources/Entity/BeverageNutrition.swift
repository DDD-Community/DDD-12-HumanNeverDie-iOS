//
//  BeverageNutrition.swift
//  BeverageDomain
//
//  Created by 김규철 on 8/8/25.
//

import Foundation

public struct BeverageNutrition: Equatable, Sendable {
  public let kcal: Int
  public let sugar: Int
  public let protein: Int
  public let saturatedFat: Int
  public let sodium: Int
  public let caffeine: Int
  
  public init(
    kcal: Int,
    sugar: Int,
    protein: Int,
    saturatedFat: Int,
    sodium: Int,
    caffeine: Int
  ) {
    self.kcal = kcal
    self.sugar = sugar
    self.protein = protein
    self.saturatedFat = saturatedFat
    self.sodium = sodium
    self.caffeine = caffeine
  }
}
