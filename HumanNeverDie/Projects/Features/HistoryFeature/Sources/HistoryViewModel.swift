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

@Observable
@MainActor
public final class HistoryViewModel :ViewModelable {
  
  public struct State: Equatable {
    var currentDate: Date = Date()
    var frequentBeverageList: [Beverage] = Beverage.frequentMockData
    var selectedBeverageID: String? = nil
    var counter: Int = 0
    var isLoading: Bool = false
    var sugarIntakeRecordData: [SugarIntakeRecord] = []
    var selectedDate: Date? = nil
    
    var weeklyHistoryData: [HistoryDaily] = []
  }
  
  public enum Action {
    case onAppear
    case beverageListFavoriteTapped(Bool, String)
    case beverageListInfoTapped(String)
    case incrementCounterAsync
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
    case .incrementCounterAsync:
      Task {
        await loadNetworkData()
      }
    }
  }
  
  private func loadNetworkData() async {
    guard !state.isLoading else { return }
    
    state.isLoading = true
    
    do {
      state.counter = 0
      let dateString = state.currentDate.toISO8601String()
      let result = try await historyUseCase.getWeeklyIntakeHistory(dateInWeek: dateString)
      print("📅 요청할 날짜: \(dateString) 📊 받은 데이터 개수: \(result.count)")
      
      state.weeklyHistoryData = result
      
      let newSugarIntakeRecordData : [SugarIntakeRecord] = result.compactMap { dailyData in
        let dateString = dailyData.date
        print("📅 처리 중인 날짜: \(dateString), 당분: \(dailyData.totalSugarGrams)")
        
        guard let date = dateString.toDate() else {
          return nil
        }
        
        if (dailyData.totalSugarGrams > 0) {
          state.counter = state.counter + 1
        }
        
        let record = SugarIntakeRecord(date: date, value: dailyData.totalSugarGrams)
        print("✅ 생성된 SugarIntakeRecord: date=\(date), value=\(dailyData.totalSugarGrams)")
        
        return record
      }
      
      state.sugarIntakeRecordData = newSugarIntakeRecordData
      print("최종 SugarIntakeRecord 개수: \(state.sugarIntakeRecordData.count)")
      
      state.isLoading = false
    } catch {
      print("❌ 히스토리 로딩 실패: \(error)")
      state.isLoading = false
    }
  }
}

extension String {
  func toDate() -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.date(from: self)
  }
}

extension Date {
  func toISO8601String() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.string(from: self)
  }
}
