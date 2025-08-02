//
// HistoryViewModel.swift
// History
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

import CommonFeature
import BeverageDomain
import HistoryDomain
import Shared

@Observable
@MainActor
public final class HistoryViewModel: ViewModelable {
  
  public struct State: Equatable {
    var currentDate: Date = Date()
    var selectedDate: Date? = nil
    
    var selectedBeverageID: String? = nil
    var isLoading: Bool = false
    
    var selectedDateHistoryList: [HistoryDailyDetail] = []
    var sugarIntakeRecordData: [SugarIntakeRecord] = []
    var monthHistoryData: [String: HistoryDaily] = [:]
    
    var totalSugarGrams = 0
    var totalCount = 0
  }
  
  public enum Action {
    case onAppear
    case beverageListFavoriteTapped(Bool, String)
    case beverageListInfoTapped(String)
    case loadHistorDailyList
    case loadHistoryForSelectedDate
    case datePickeronConfirm
  }
  
  public var state: State = .init()
  private let historyUseCase: HistoryUseCaseProtocol
  public init(historyUseCase: HistoryUseCaseProtocol = HistoryUseCase()) {
    self.historyUseCase = historyUseCase
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
    case .beverageListFavoriteTapped(_, _):
      break
    case .beverageListInfoTapped(let id):
      state.selectedBeverageID = id
      
      break
    case .loadHistorDailyList:
      Task {
        await loadNetworkData()
      }
    case .loadHistoryForSelectedDate:
      loadSelectedDateHistory()
      
    case .datePickeronConfirm:
      Task {
        await loadNetworkData()
        loadSelectedDateHistory()
      }
      
    }
  }
}

extension HistoryViewModel {
  
  private func resetSelectedData() {
    state.selectedDateHistoryList = []
    state.totalSugarGrams = 0
    state.totalCount = 0
  }
  
  private func loadNetworkData() async {
    guard !state.isLoading else { return }
    
    state.isLoading = true
    state.monthHistoryData.removeAll()
    
    do {
      let dateString = state.currentDate.toISO8601String()
      let result = try await historyUseCase.getWeeklyIntakeHistory(dateInWeek: dateString)
      
      let newSugarIntakeRecordData: [SugarIntakeRecord] = result.compactMap { dailyData in
        
        let dateKey = String(dailyData.date.prefix(10))
        state.monthHistoryData[dateKey] = dailyData
        
        guard let date = dailyData.date.toDate() else { return nil }
        return SugarIntakeRecord(date: date, value: dailyData.totalSugarGrams)
      }
      
      state.sugarIntakeRecordData = newSugarIntakeRecordData
      state.isLoading = false
      
    } catch {
      print("❌ 히스토리 로딩 실패: \(error)")
      state.isLoading = false
    }
  }
  
  private func loadSelectedDateHistory() {
    guard let selectedDate = state.selectedDate else {
      resetSelectedData()
      return
    }
    
    let dateKey = selectedDate.toISO8601String().prefix(10)
    
    if let dailyData = state.monthHistoryData[String(dateKey)] {
      state.totalSugarGrams = dailyData.totalSugarGrams
      state.totalCount = dailyData.records.count
      state.selectedDateHistoryList = dailyData.records
    } else {
      resetSelectedData()
    }
  }
}
