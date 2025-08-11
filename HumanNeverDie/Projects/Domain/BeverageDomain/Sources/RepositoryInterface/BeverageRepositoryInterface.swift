//
//  BeverageRepositoryInterface.swift
//  BeverageDomain
//
//  Created by 김규철 on 2025/07/02.
//

import Foundation

public protocol BeverageRepositoryInterface: Sendable {
  func getBeverageCount() async throws -> BeverageCount
  func getBeverageList(cursor: String?) async throws -> BeverageList
  func getBeverageDetail(productID: String) async throws -> BeverageDetail
  func getBeverageMonthCalender(dateInWeek: String) async throws -> [BeverageCalendar]
  func getBeverageWeeklyCalender(dateInWeek: String) async throws -> [BeverageCalendar]
  func likeBeverage(productID: String) async throws -> BeverageLike
  func unLikeBeverage(productID: String) async throws -> BeverageLike
  func searchBeverage(keyword: String) async throws -> BeverageList
  func recordBeverage(productID: String, recordDate: Date) async throws -> Int
  
}
