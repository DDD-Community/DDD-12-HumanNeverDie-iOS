//
//  BeverageNutritionResponse.swift
//  Data
//
//  Created by 김규철 on 8/8/25.
//

import Foundation

struct BeverageNutritionResponse: Decodable {
  let servingKcal: Int?
  let saturatedFatG: Double?
  let proteinG: Int?
  let sodiumMg: Int?
  let sugarG: Int?
  let caffeineMg: Int?
  
  init(
    servingKcal: Int?,
    saturatedFatG: Double?,
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
