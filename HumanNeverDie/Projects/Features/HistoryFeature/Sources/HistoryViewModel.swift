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
import Shared

import Dependencies

@Observable
@MainActor
public final class HistoryViewModel: ViewModelable {
  public struct State: Equatable {
    var currentDate: Date = Date()
    var selectedDate: Date? = nil
    var isMonthPickerPresented = false
    
    var selectedBeverageID: String = ""
    var isLoading: Bool = false
    
    var selectedDateHistoryList: [BeverageCalendarRecoders] = []
    var sugarIntakeRecordData: [SugarIntakeRecord] = []
    var monthHistoryData: [String: BeverageCalendar] = [:]
    
    var totalSugarGrams = 0
    var totalCount = 0
  }
  
  public enum Action {
    case onAppear
    case beverageListFavoriteTapped(Bool, String)
    case beverageListInfoTapped
    case loadHistorDailyList
    case loadHistoryForSelectedDate
    case datePickeronConfirm
    case updateCurrentDate(Date)
    case updateSelectedBeverageID(String)
    case updateisMonthPickerPresented(Bool)
    case applySelectedDate(Date)
  }
  
  public var state: State = .init()
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        await loadNetworkData()
        loadSelectedDateHistory()
      }
    case .beverageListFavoriteTapped(_, _):
      break
    case .beverageListInfoTapped:
      // state.selectedBeverageID 설명창띄우기
      //띄우고 초기화
      state.selectedBeverageID = ""
      
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
      
    case .updateCurrentDate(let newDate):
      state.currentDate = newDate
      
    case .updateSelectedBeverageID(let newId):
      state.selectedBeverageID = newId
      
    case .updateisMonthPickerPresented(let isPickerPresented):
      state.isMonthPickerPresented = isPickerPresented
      
    case .applySelectedDate(let newDate):
     state.currentDate = newDate
     state.selectedDate = newDate
      state.isMonthPickerPresented = false
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
      let dateString = Date.toRequestDateKeyString(from:state.currentDate)
      let result = try await beverageUseCase.getBeverageMonthCalender(dateInWeek: dateString)
      
      let newSugarIntakeRecordData: [SugarIntakeRecord] = result.compactMap { dailyData in
        
        let dateKey = dailyData.date.toYMDFormat
        state.monthHistoryData[dateKey] = dailyData
        
        guard let date = String.toDate(from: dailyData.date) else { return nil }
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
    
    let dateKey = Date.toDateKeyString(from: selectedDate)
    
    if let dailyData = state.monthHistoryData[String(dateKey)] {
      state.totalSugarGrams = dailyData.totalSugarGrams
      state.totalCount = dailyData.records.count
      state.selectedDateHistoryList = dailyData.records
    } else {
      resetSelectedData()
    }
  }
  
  var selectedDateHistoryListArray: [BeverageCalendarRecoders] {
    return state.selectedDateHistoryList
  }
}

