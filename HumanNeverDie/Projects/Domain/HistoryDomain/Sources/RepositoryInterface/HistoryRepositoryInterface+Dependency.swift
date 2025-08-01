//
//  HistoryRepositoryInterface+Dependency.swift
//  HistoryDomain
//
//  Created by Seulki Lee on 8/1/25.
//

import Dependencies

// MARK: - TestDependencyKey

public struct HistoryRepositoryKey: TestDependencyKey {
  public static let testValue: HistoryRepositoryInterface = MockHistoryRepository()
}

// MARK: - DependencyValues

public extension DependencyValues {
  var historyRepository: HistoryRepositoryInterface {
    get { self[HistoryRepositoryKey.self] }
    set { self[HistoryRepositoryKey.self] = newValue }
  }
}

// MARK: - MockMainRepository

private struct MockHistoryRepository: HistoryRepositoryInterface {
  func getWeeklyIntakeHistory(dateInWeek: String) async throws -> [HistoryDaily] { HistoryDaily.mockData }

}

