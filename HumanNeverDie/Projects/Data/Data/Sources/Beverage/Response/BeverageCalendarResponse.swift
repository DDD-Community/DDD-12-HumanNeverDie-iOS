//
//  HistoryCalendarListResponse.swift
//  Data
//
//  Created by Seulki Lee on 8/7/25.
//

import Foundation

import BeverageDomain

public struct BeverageCalendarResponse: Decodable {
    public let date: String
    public let records: [CalendarRecord]
    public let totalKcal: Int
    public let totalSugarGrams: Int
    public let totalCaffeine: Int
    
    public var id: String { date }
    
    public init(
        date: String,
        records: [CalendarRecord],
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
public struct CalendarRecord: Decodable {
    public let intakeHistoryId: Int
    public let beverageId: Int
    public let beverageName: String
    public let cafeBrand: String
    public let intakeTime: String
    public let nutrition: Nutrition
    public let imgUrl: String
    public let sugarLevel: String
    public let beverageSize: String
    
    public var id: Int { intakeHistoryId }
    
    public init(
        intakeHistoryId: Int,
        beverageId: Int,
        beverageName: String,
        cafeBrand: String,
        intakeTime: String,
        nutrition: Nutrition,
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
public struct Nutrition: Decodable, Equatable, Sendable {
    public let servingKcal: Int
    public let saturatedFatG: Double
    public let proteinG: Int
    public let sodiumMg: Int
    public let sugarG: Int
    public let caffeineMg: Int
    
    public init(
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
    func toDomain() -> [BeverageCalendar] {
        return self.map { $0.toDomain() }
    }
}


public extension BeverageCalendarResponse {
  func toDomain() -> BeverageCalendar {
    return BeverageCalendar(
      date: self.date,
      records: self.records.map { $0.toDomain() },
      totalKcal: self.totalKcal,
      totalSugarGrams: self.totalSugarGrams,
      totalCaffeine: self.totalCaffeine
    )
  }
}

public extension CalendarRecord {
  func toDomain() -> BeverageCalendarRecoders {
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
