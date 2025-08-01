//
//  HistoryUseCase.swift
//  HistoryDomain
//
//  Created by Seulki Lee on 2025/07/30.
//

import Foundation
import Dependencies

public protocol HistoryUseCaseProtocol: Sendable {
  func getWeeklyIntakeHistory(dateInWeek: String) async throws -> [HistoryDaily]
}

public final class HistoryUseCase: HistoryUseCaseProtocol, @unchecked Sendable {
  @Dependency(\.historyRepository) private var historyRepository
  public init() {}
  
  public func getWeeklyIntakeHistory(dateInWeek: String) async throws -> [HistoryDaily] {
      return try await historyRepository.getWeeklyIntakeHistory(dateInWeek: dateInWeek)
  }
    // Implement your use case methods here
} 
