//
//  HistoryRepository.swift
//  Data
//
//  Created by Seulki Lee on 8/1/25.
//

import Foundation

import BaseNetwork
import HistoryDomain

import Dependencies

public final class HistoryRepository: HistoryRepositoryInterface, @unchecked Sendable {
  @Dependency(\.networkService) private var networkService
  public init() {}
  
  
  public func getWeeklyIntakeHistory(dateInWeek: String) async throws -> [HistoryDaily] {
    let target = HistoryMonthCalenderTarget(dateInMonth: dateInWeek)
    let response = try await networkService.requestDDD(target)

    guard let responseData = response.data else {
      throw AMDNetworkError.emptyResponse
    }

    return responseData
  }
}
