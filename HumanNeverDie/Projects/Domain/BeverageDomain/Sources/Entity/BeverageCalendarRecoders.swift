//
//  BeverageCalendarRecoders.swift
//  BeverageDomain
//
//  Created by Seulki Lee on 8/7/25.
//

import Foundation


public struct BeverageCalendarRecoders: Equatable, Sendable {
  public let intakeHistoryId: Int
  public let productId: String
  public let beverageName: String
  public let brandType: BeverageBrandType?
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
  public let sugarMaxG: Int
  public let sugarIdealG: Int
  
  public init(
    intakeHistoryId: Int,
    productId: String,
    beverageName: String,
    brandType: BeverageBrandType?,
    intakeTime: String,
    sugarLevel: String,
    servingKcal: Int,
    saturatedFatG: Double,
    proteinG: Int,
    sodiumMg: Int,
    sugarG: Int,
    caffeineMg: Int,
    imgUrl: String,
    beverageSize: String,
    sugarMaxG: Int,
    sugarIdealG: Int
  ){
    self.intakeHistoryId = intakeHistoryId
    self.productId = productId
    self.beverageName = beverageName
    self.brandType = brandType
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
    self.sugarMaxG = sugarMaxG
    self.sugarIdealG = sugarIdealG
  }
}
