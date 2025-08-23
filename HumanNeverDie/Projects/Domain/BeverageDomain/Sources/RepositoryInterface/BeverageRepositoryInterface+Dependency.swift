//
//  BeverageRepositoryInterface+Dependency.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import Dependencies

// MARK: - TestDependencyKey

public struct BeverageRepositoryKey: TestDependencyKey {
  public static let testValue: BeverageRepositoryInterface = MockBeverageRepository()
}

// MARK: - DependencyValues

extension DependencyValues {
  var beverageRepository: BeverageRepositoryInterface {
    get { self[BeverageRepositoryKey.self] }
    set { self[BeverageRepositoryKey.self] = newValue }
  }
}

// MARK: - MockMainRepository

private struct MockBeverageRepository: BeverageRepositoryInterface {
  func getBeverageCount() async throws -> BeverageCount { BeverageCount.mock() }
  func getBeverageList(cursor: String?, sugarLevel: String?, onlyLiked: Bool) async throws -> BeverageList { BeverageList.mock() }
  func getBeverageDetail(productID: String) async throws -> BeverageDetail { BeverageDetail.mock() }
  func getBeverageMonthCalender(dateInWeek: String) async throws -> [BeverageCalendar] { BeverageCalendar.mock() }
  func getBeverageWeeklyCalender(dateInWeek: String) async throws -> [BeverageCalendar] { BeverageCalendar.mock() }
  func getBeveragDailyCalender(dailyDate: String) async throws -> BeverageCalendar { BeverageCalendar.dailyMock() }
  func likeBeverage(productID: String) async throws -> BeverageLike { BeverageLike.mock() }
  func unLikeBeverage(productID: String) async throws -> BeverageLike { BeverageLike.mock() }
  func searchBeverage(keyword: String, sugarLevel: String?, onlyLiked: Bool) async throws -> BeverageList { BeverageList.mock() }
  func recordBeverage(productID: String, recordDate: Date) async throws -> Int { 500 }
  func deleteBeverage(productID: String, intakeTime: String) async throws -> Int { 200 }
}
