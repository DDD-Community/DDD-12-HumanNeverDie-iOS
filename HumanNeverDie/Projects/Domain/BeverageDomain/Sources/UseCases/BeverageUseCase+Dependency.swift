//
//  BeverageUseCase+Dependency.swift
//  BeverageDomain
//
//  Created by 김규철 on 7/10/25.
//

import Foundation

import Dependencies

// MARK: - TestDependencyKey

public struct BeverageUseCaseKey: TestDependencyKey {
  public static let testValue: BeverageUseCaseProtocol = MockBeverageUseCase()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var beverageUseCase: BeverageUseCaseProtocol {
    get { self[BeverageUseCaseKey.self] }
    set { self[BeverageUseCaseKey.self] = newValue }
  }
}

// MARK: - MockMainRepository

private struct MockBeverageUseCase: BeverageUseCaseProtocol {
  func getBeverageCount() async throws -> BeverageCount { BeverageCount.mock() }
  func getBeverageList(cursor: String?, sugarLevel: BeverageSugarLevelType?, onlyLiked: Bool) async throws -> BeverageList { BeverageList.mock() }
  func getBeverageDetail(productID: String) async throws -> BeverageDetail { BeverageDetail.mock() }
  func getBeverageMonthCalender(dateInWeek: String) async throws -> [BeverageCalendar] { BeverageCalendar.mock() }
  func getBeverageWeeklyCalender(dateInWeek: String) async throws -> [BeverageCalendar] { BeverageCalendar.mock() }
  func likeBeverage(productID: String) async throws -> BeverageLike { BeverageLike.mock() }
  func unLikeBeverage(productID: String) async throws -> BeverageLike { BeverageLike.mock() }
  func searchBeverage(keyword: String, sugarLevel: BeverageSugarLevelType?, onlyLiked: Bool) async throws -> BeverageList { BeverageList.mock() }
  func recordBeverage(productID: String, recordDate: Date) async throws -> Bool { false }
  func syncBeverageLike(beverages: [Beverage]) throws -> ([Beverage], Int) { (beverages, 0) }
  func deleteBeverage(productID: String, intakeTime: String) async throws -> Bool { true }
}
