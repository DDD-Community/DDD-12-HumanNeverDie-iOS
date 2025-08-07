//
//  BeverageCalendarRecoders.swift
//  BeverageDomain
//
//  Created by Seulki Lee on 8/7/25.
//

import Foundation


public struct BeverageCalendarRecoders: Decodable, Equatable, Identifiable, Sendable {
  public let intakeHistoryId: Int
  public let beverageId: Int
  public let beverageName: String
  public let cafeBrand: String
  public let intakeTime: String
  public let sugarLevel: String
  public let servingKcal: Int
  public let saturatedFatG: Double
  public let proteinG: Int
  public let sodiumMg: Int
  public let sugarG: Int
  public let caffeineMg: Int
  public let imgUrl: String
  public let beverageSize : String
  
  public var id: Int { intakeHistoryId }
  
  private enum CodingKeys: String, CodingKey {
    case intakeHistoryId, beverageId, beverageName, cafeBrand, intakeTime, sugarLevel, nutrition, imgUrl, beverageSize
  }
  
  private enum NutritionKeys: String, CodingKey {
    case servingKcal, saturatedFatG, proteinG, sodiumMg, sugarG, caffeineMg
  }
  
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    intakeHistoryId = try container.decode(Int.self, forKey: .intakeHistoryId)
    beverageId = try container.decode(Int.self, forKey: .beverageId)
    beverageName = try container.decode(String.self, forKey: .beverageName)
    cafeBrand = try container.decode(String.self, forKey: .cafeBrand)
    intakeTime = try container.decode(String.self, forKey: .intakeTime)
    sugarLevel = try container.decode(String.self, forKey: .sugarLevel)
    imgUrl = try container.decode(String.self, forKey: .imgUrl)
    beverageSize =  try container.decode(String.self, forKey: .beverageSize)
    
    // nutrition 객체에서 필드들 추출
    let nutritionContainer = try container.nestedContainer(keyedBy: NutritionKeys.self, forKey: .nutrition)
    servingKcal = try nutritionContainer.decode(Int.self, forKey: .servingKcal)
    saturatedFatG = try nutritionContainer.decode(Double.self, forKey: .saturatedFatG)
    proteinG = try nutritionContainer.decode(Int.self, forKey: .proteinG)
    sodiumMg = try nutritionContainer.decode(Int.self, forKey: .sodiumMg)
    sugarG = try nutritionContainer.decode(Int.self, forKey: .sugarG)
    caffeineMg = try nutritionContainer.decode(Int.self, forKey: .caffeineMg)
  }
  
  public init(
    intakeHistoryId: Int,
    beverageId: Int,
    beverageName: String,
    cafeBrand: String,
    intakeTime: String,
    sugarLevel: String,
    servingKcal: Int,
    saturatedFatG: Double,
    proteinG: Int,
    sodiumMg: Int,
    sugarG: Int,
    caffeineMg: Int,
    imgUrl: String,
    beverageSize: String
  ) {
    self.intakeHistoryId = intakeHistoryId
    self.beverageId = beverageId
    self.beverageName = beverageName
    self.cafeBrand = cafeBrand
    self.intakeTime = intakeTime
    self.sugarLevel = sugarLevel
    self.servingKcal = servingKcal
    self.saturatedFatG = saturatedFatG
    self.proteinG = proteinG
    self.sodiumMg = sodiumMg
    self.sugarG = sugarG
    self.caffeineMg = caffeineMg
    self.imgUrl = imgUrl
    self.beverageSize = beverageSize
  }
}
