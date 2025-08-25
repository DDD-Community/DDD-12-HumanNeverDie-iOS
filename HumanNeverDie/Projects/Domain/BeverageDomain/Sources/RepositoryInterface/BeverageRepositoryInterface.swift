//
//  BeverageRepositoryInterface.swift
//  BeverageDomain
//
//  Created by 김규철 on 2025/07/02.
//

import Foundation

public protocol BeverageRepositoryInterface: Sendable {
  func getBeverageCount() async throws -> BeverageCount
  func getBeverageList(cursor: String?, sugarLevel: String?, onlyLiked: Bool) async throws -> BeverageList
  func getBeverageDetail(productID: String) async throws -> BeverageDetail
  func getBeverageMonthCalender(dateInWeek: String) async throws -> [BeverageCalendar]
  func getBeverageWeeklyCalender(dateInWeek: String) async throws -> [BeverageCalendar]
  func getBeveragDailyCalender(dailyDate: String) async throws -> BeverageCalendar
  func likeBeverage(productID: String) async throws -> BeverageLike
  func unLikeBeverage(productID: String) async throws -> BeverageLike
  func searchBeverage(keyword: String, sugarLevel: String?, onlyLiked: Bool) async throws -> BeverageList
  func recordBeverage(productID: String, recordDate: Date, size: String) async throws -> Int
  func deleteBeverage(productID: String, intakeTime: String) async throws -> Int
  
}
