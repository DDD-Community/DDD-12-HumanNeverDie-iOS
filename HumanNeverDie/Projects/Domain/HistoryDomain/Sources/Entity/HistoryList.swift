//
//  HistoryList.swift
//  HistoryDomain
//
//  Created by Seulki Lee on 2025/07/30.
//

import Foundation

public struct HistoryList: Equatable, Sendable {
    public let date: String
    public let records: [IntakeHistoryRecord]
    public let totalKcal: Int
    public let totalSugarGrams: Int
    public let totalCaffeine: Int
    
    public init(
        date: String,
        records: [IntakeHistoryRecord],
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

public struct IntakeHistoryRecord: Equatable, Sendable, Identifiable {
    public let id: Int // intakeHistoryId
    public let beverageId: Int
    public let beverageName: String
    public let cafeBrand: String
    public let intakeTime: String
    public let nutrition: Nutrition
    public let sugarLevel: SugarLevel
    
    public init(
        id: Int,
        beverageId: Int,
        beverageName: String,
        cafeBrand: String,
        intakeTime: String,
        nutrition: Nutrition,
        sugarLevel: SugarLevel
    ) {
        self.id = id
        self.beverageId = beverageId
        self.beverageName = beverageName
        self.cafeBrand = cafeBrand
        self.intakeTime = intakeTime
        self.nutrition = nutrition
        self.sugarLevel = sugarLevel
    }
}

public struct Nutrition: Equatable, Sendable {
    public let servingKcal: Int
    public let saturatedFatG: Int
    public let proteinG: Int
    public let sodiumMg: Int
    public let sugarG: Int
    public let caffeineMg: Int
    
    public init(
        servingKcal: Int,
        saturatedFatG: Int,
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

public enum SugarLevel: String, Equatable, Sendable, CaseIterable {
    case high = "HIGH"
    case medium = "MEDIUM"
    case low = "LOW"
    case zero = "ZERO"
}

// MARK: - Mock Extension
extension HistoryList {
    public static func mock() -> HistoryList {
        .init(
            date: "2025-07-26T17:30:00",
            records: IntakeHistoryRecord.mockData,
            totalKcal: 580,
            totalSugarGrams: 36,
            totalCaffeine: 390
        )
    }
}

extension IntakeHistoryRecord {
    public static var mockData: [IntakeHistoryRecord] {
        [
            IntakeHistoryRecord(
                id: 1,
                beverageId: 1,
                beverageName: "밀크카라멜 라떼",
                cafeBrand: "STARBUCKS",
                intakeTime: "2025-07-26T06:30:00",
                nutrition: Nutrition(
                    servingKcal: 310,
                    saturatedFatG: 13,
                    proteinG: 8,
                    sodiumMg: 280,
                    sugarG: 22,
                    caffeineMg: 75
                ),
                sugarLevel: .high
            ),
            IntakeHistoryRecord(
                id: 6,
                beverageId: 16,
                beverageName: "사케라또 비안코 오버 아이스",
                cafeBrand: "STARBUCKS",
                intakeTime: "2025-07-26T11:30:00",
                nutrition: Nutrition(
                    servingKcal: 270,
                    saturatedFatG: 18,
                    proteinG: 3,
                    sodiumMg: 45,
                    sugarG: 14,
                    caffeineMg: 315
                ),
                sugarLevel: .low
            )
        ]
    }
}

extension Nutrition {
    public static func mock() -> Nutrition {
        .init(
            servingKcal: 310,
            saturatedFatG: 13,
            proteinG: 8,
            sodiumMg: 280,
            sugarG: 22,
            caffeineMg: 75
        )
    }
}