//
//  HistoryRepositoryInterface.swift
//  HistoryDomain
//
//  Created by Seulki Lee on 2025/07/30.
//

import Foundation

public protocol HistoryRepositoryInterface: Sendable {
  func getWeeklyIntakeHistory(dateInWeek: String) async throws -> [HistoryDaily]
}
