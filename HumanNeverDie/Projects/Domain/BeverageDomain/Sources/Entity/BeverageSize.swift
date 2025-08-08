//
//  BeverageSize.swift
//  BeverageDomain
//
//  Created by 김규철 on 8/8/25.
//

import Foundation

public struct BeverageSize: Equatable, Sendable {
  public let sizeType: String
  public let nutrition: BeverageNutrition
  
  public init(
    sizeType: String,
    nutrition: BeverageNutrition
  ) {
    self.sizeType = sizeType
    self.nutrition = nutrition
  }
}
