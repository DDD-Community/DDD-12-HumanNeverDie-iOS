//
//  HistoryDailyData.swift
//  HistoryDomain
//
//  Created by Seulki Lee on 8/1/25.
//

import Foundation

public struct HistoryDaily: Decodable, Equatable, Identifiable, Sendable {
    public let date: String
    public let records: [HistoryDailyDetail]
    public let totalKcal: Int
    public let totalSugarGrams: Int
    public let totalCaffeine: Int
    
    public var id: String { date }
    
    public init(date: String, records: [HistoryDailyDetail], totalKcal: Int, totalSugarGrams: Int, totalCaffeine: Int) {
        self.date = date
        self.records = records
        self.totalKcal = totalKcal
        self.totalSugarGrams = totalSugarGrams
        self.totalCaffeine = totalCaffeine
    }
}
