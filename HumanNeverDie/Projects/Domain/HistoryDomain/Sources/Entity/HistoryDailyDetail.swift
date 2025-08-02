//
//  HistoryDailyDetail.swift
//  HistoryDomain
//
//  Created by Seulki Lee on 8/2/25.
//

import Foundation


public struct HistoryDailyDetail: Decodable, Equatable, Identifiable, Sendable {
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

public extension HistoryDaily {
  static var mockData: [HistoryDaily] {
    [
      HistoryDaily(
        date: "2025-07-04T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-05T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-06T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-07T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-08T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-09T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-10T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-11T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-12T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-13T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-14T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-15T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-16T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-17T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-18T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-19T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-20T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-21T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-22T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-23T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-24T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-25T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      // 👇 실제 데이터가 있는 날!
      HistoryDaily(
        date: "2025-07-26T00:00:00",
        records: [
          HistoryDailyDetail(
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
          HistoryDailyDetail(
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
      HistoryDaily(
        date: "2025-07-27T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-28T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-29T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-30T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-07-31T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-08-01T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-08-02T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      ),
      HistoryDaily(
        date: "2025-08-03T00:00:00",
        records: [],
        totalKcal: 0,
        totalSugarGrams: 0,
        totalCaffeine: 0
      )
    ]
  }
}
