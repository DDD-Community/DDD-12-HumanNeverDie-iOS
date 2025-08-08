//
//  BeverageCalendarRecoders.swift
//  BeverageDomain
//
//  Created by Seulki Lee on 8/7/25.
//

import Foundation


public struct BeverageCalendarRecoders: Equatable, Sendable {
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
