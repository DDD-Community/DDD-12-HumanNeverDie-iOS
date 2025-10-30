//
//  HistoryCalendarListResponse.swift
//  Data
//
//  Created by Seulki Lee on 8/7/25.
//

import Foundation
import BeverageDomain

struct BeverageCalendarResponse: Decodable {
  let date: String
  let records: [CalendarRecordResponse]
  let totalKcal: Int
  let totalSugarGrams: Int
  let totalCaffeine: Int
  let recommendedSugar: RecommendedSugarResponse
  
  init(
    date: String,
    records: [CalendarRecordResponse],
    totalKcal: Int,
    totalSugarGrams: Int,
    totalCaffeine: Int,
    recommendedSugar: RecommendedSugarResponse
  ) {
    self.date = date
    self.records = records
    self.totalKcal = totalKcal
    self.totalSugarGrams = totalSugarGrams
    self.totalCaffeine = totalCaffeine
    self.recommendedSugar = recommendedSugar
  }
}

struct RecommendedSugarResponse: Decodable {
  let sugarMaxG: Int
  let sugarIdealG: Int
  
  init(sugarMaxG: Int, sugarIdealG: Int) {
    self.sugarMaxG = sugarMaxG
    self.sugarIdealG = sugarIdealG
  }
}

struct CalendarRecordResponse: Decodable {
  let intakeHistoryId: Int
  let productId: String
  let beverageName: String
  let cafeBrand: String
  let intakeTime: String
  let nutrition: BeverageNutritionResponse
  let imgUrl: String
  let sugarLevel: String
  let beverageSize: String
  
  init(
    intakeHistoryId: Int,
    productId: String,
    beverageName: String,
    cafeBrand: String,
    intakeTime: String,
    nutrition: BeverageNutritionResponse,
    imgUrl: String,
    sugarLevel: String,
    beverageSize: String
  ) {
    self.intakeHistoryId = intakeHistoryId
    self.productId = productId
    self.beverageName = beverageName
    self.cafeBrand = cafeBrand
    self.intakeTime = intakeTime
    self.nutrition = nutrition
    self.imgUrl = imgUrl
    self.sugarLevel = sugarLevel
    self.beverageSize = beverageSize
  }
}

// MARK: - Domain Conversion Extensions

extension BeverageCalendarResponse {
  public func toDomain() -> BeverageCalendar {
    return BeverageCalendar(
      date: self.date,
      records: self.records.map {
        $0.toDomain(
          sugarMaxG: self.recommendedSugar.sugarMaxG,
          sugarIdealG: self.recommendedSugar.sugarIdealG
        )
      },
      totalKcal: self.totalKcal,
      totalSugarGrams: self.totalSugarGrams,
      totalCaffeine: self.totalCaffeine,
      sugarMaxG: self.recommendedSugar.sugarMaxG,     // 풀어서 전달
      sugarIdealG: self.recommendedSugar.sugarIdealG  // 풀어서 전달
    )
  }
}

extension CalendarRecordResponse {
  public func toDomain(sugarMaxG: Int, sugarIdealG: Int) -> BeverageCalendarRecoders {
    return BeverageCalendarRecoders(
      intakeHistoryId: self.intakeHistoryId,
      productId: self.productId,
      beverageName: self.beverageName,
      brandType: self.cafeBrand,
      intakeTime: self.intakeTime,
      sugarLevel: self.sugarLevel,
      servingKcal: self.nutrition.servingKcal ?? 0,
      saturatedFatG: self.nutrition.saturatedFatG ?? 0,
      proteinG: self.nutrition.proteinG ?? 0,
      sodiumMg: self.nutrition.sodiumMg ?? 0,
      sugarG: self.nutrition.sugarG ?? 0,
      caffeineMg: self.nutrition.caffeineMg ?? 0,
      imgUrl: self.imgUrl,
      beverageSize: self.beverageSize.capitalized,
      sugarMaxG: sugarMaxG,
      sugarIdealG: sugarIdealG
    )
  }
}
