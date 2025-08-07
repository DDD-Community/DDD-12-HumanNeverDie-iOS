//
//  BeverageHistoryCalendarList.swift
//  BeverageDomain
//
//  Created by Seulki Lee on 8/7/25.
//

import Foundation

public struct BeverageCalendar: Equatable, Sendable {
  public let date: String
  public let records: [BeverageCalendarRecoders]
  public let totalKcal: Int
  public let totalSugarGrams: Int
  public let totalCaffeine: Int
  
  public init(
      date: String,
      records: [BeverageCalendarRecoders],
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

public extension BeverageCalendar {
  static func mock() -> [BeverageCalendar] { mockData }
  
  private static var mockData: [BeverageCalendar] {
    [
      BeverageCalendar(
        date: "2025-07-04T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-05T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-06T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-07T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-08T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-09T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-10T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-11T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-12T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-13T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-14T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-15T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-16T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-17T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-18T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-19T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-20T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-21T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-22T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-23T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-24T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-25T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      // 👇 실제 데이터가 있는 날!
      BeverageCalendar(
        date: "2025-07-26T00:00:00",
        records: [
          BeverageCalendarRecoders(
            intakeHistoryId: 1,
            beverageId: 1,
            beverageName: "밀크카라멜 라떼",
            cafeBrand: "STARBUCKS",
            intakeTime: "2025-07-26T06:30:00",
            sugarLevel: "HIGH",
            servingKcal: 310,
            saturatedFatG: 13,
            proteinG: 8,
            sodiumMg: 280,
            sugarG: 22,
            caffeineMg: 75,
            imgUrl: "https://www.starbucks.co.kr/upload/store/skuimg/2025/06/[110601]_20250626095213930.jpg",
            beverageSize: "Tall"
          ),
          BeverageCalendarRecoders(
            intakeHistoryId: 6,
            beverageId: 16,
            beverageName: "사케라또 비안코 오버 아이스",
            cafeBrand: "STARBUCKS",
            intakeTime: "2025-07-26T11:30:00",
            sugarLevel: "LOW",
            servingKcal: 270,
            saturatedFatG: 18,
            proteinG: 3,
            sodiumMg: 45,
            sugarG: 14,
            caffeineMg: 315,
            imgUrl: "https://www.starbucks.co.kr/upload/store/skuimg/2025/06/[110601]_20250626095213930.jpg",
            beverageSize: "Tall"
          )
        ],
        totalKcal: 580,
        totalSugarGrams: 36,
        totalCaffeine: 390
      ),
      BeverageCalendar(
        date: "2025-07-27T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-28T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-29T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-30T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-07-31T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-08-01T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-08-02T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      BeverageCalendar(
        date: "2025-08-03T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      )
    ]
  }
}

