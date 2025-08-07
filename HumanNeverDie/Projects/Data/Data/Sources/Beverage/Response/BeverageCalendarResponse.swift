//
//  HistoryCalendarListResponse.swift
//  Data
//
//  Created by Seulki Lee on 8/7/25.
//

import Foundation

import BeverageDomain

public struct BeverageCalendarResponse: Decodable {
    let date: String
    let records: [CalendarRecordResponse]
    let totalKcal: Int
    let totalSugarGrams: Int
    let totalCaffeine: Int
    
    init(
        date: String,
        records: [CalendarRecordResponse],
        totalKcal: Int,
        totalSugarGrams: Int,
        totalCaffeine: Int
    ) {
        self.date = date
        self.records = records
        self.totalKcal = totalKcal
        self.totalSugarGrams = totalSugarGrams
        self.totalCaffeine = totalCaffeine
    }
}

// MARK: - Individual Record
struct CalendarRecordResponse: Decodable {
    let intakeHistoryId: Int
    let beverageId: Int
    let beverageName: String
    let cafeBrand: String
    let intakeTime: String
    let nutrition: NutritionResponse
    let imgUrl: String
    let sugarLevel: String
    let beverageSize: String
    
    init(
        intakeHistoryId: Int,
        beverageId: Int,
        beverageName: String,
        cafeBrand: String,
        intakeTime: String,
        nutrition: NutritionResponse,
        imgUrl: String,
        sugarLevel: String,
        beverageSize: String
    ) {
        self.intakeHistoryId = intakeHistoryId
        self.beverageId = beverageId
        self.beverageName = beverageName
        self.cafeBrand = cafeBrand
        self.intakeTime = intakeTime
        self.nutrition = nutrition
        self.imgUrl = imgUrl
        self.sugarLevel = sugarLevel
        self.beverageSize = beverageSize
    }
}

// MARK: - Nutrition Information
struct NutritionResponse: Decodable {
    let servingKcal: Int
    let saturatedFatG: Double
    let proteinG: Int
    let sodiumMg: Int
    let sugarG: Int
    let caffeineMg: Int
    
    init(
        servingKcal: Int,
        saturatedFatG: Double,
        proteinG: Int,
        sodiumMg: Int,
        sugarG: Int,
        caffeineMg: Int
    ) {
        self.servingKcal = servingKcal
        self.saturatedFatG = saturatedFatG
        self.proteinG = proteinG
        self.sodiumMg = sodiumMg
        self.sugarG = sugarG
        self.caffeineMg = caffeineMg
    }
}

extension Array where Element == BeverageCalendarResponse {
    public func toDomain() -> [BeverageCalendar] {
        return self.map { $0.toDomain() }
    }
}


extension BeverageCalendarResponse {
  public func toDomain() -> BeverageCalendar {
    return BeverageCalendar(
      date: self.date,
      records: self.records.map { $0.toDomain() },
      totalKcal: self.totalKcal,
      totalSugarGrams: self.totalSugarGrams,
      totalCaffeine: self.totalCaffeine
    )
  }
}

extension CalendarRecordResponse {
  public func toDomain() -> BeverageCalendarRecoders {
    return BeverageCalendarRecoders(
      intakeHistoryId: self.intakeHistoryId,
      beverageId: self.beverageId,
      beverageName: self.beverageName,
      cafeBrand: self.cafeBrand,
      intakeTime: self.intakeTime,
      sugarLevel: self.sugarLevel,
      servingKcal: self.nutrition.servingKcal,
      saturatedFatG: self.nutrition.saturatedFatG,
      proteinG: self.nutrition.proteinG,
      sodiumMg: self.nutrition.sodiumMg,
      sugarG: self.nutrition.sugarG,
      caffeineMg: self.nutrition.caffeineMg,
      imgUrl: self.imgUrl,
      beverageSize: self.beverageSize
    )
  }
}
