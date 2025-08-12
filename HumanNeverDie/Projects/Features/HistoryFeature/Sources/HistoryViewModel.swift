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
    
    var selectedProductID: String = ""
    var isMonthPickerPresented = false
    var isListPopupPresented: Bool { !selectedProductID.isEmpty }
    var isBevarageDetailPresented = false
    
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
    case updateSelectedproductID(String)
    case updateisMonthPickerPresented(Bool)
    case applySelectedDate(Date)
    case clearSelectedBeverage
    case deleteSelectedBeverage
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
      state.isBevarageDetailPresented = true
      
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
      
    case .updateSelectedproductID(let newId):
      state.selectedProductID = newId
      
    case .clearSelectedBeverage:
      clearSelectedProductID()
      
    case .updateisMonthPickerPresented(let isPickerPresented):
      state.isMonthPickerPresented = isPickerPresented
      
    case .applySelectedDate(let newDate):
      state.currentDate = newDate
      state.selectedDate = newDate
      state.isMonthPickerPresented = false
    case .deleteSelectedBeverage:
      Task {
        await deleteSelectedBeverage()
      }
    }
  }
}

extension HistoryViewModel {
  
  private func deleteSelectedBeverage() async {
    guard let selectedDate = state.selectedDate else { return }
    let dateKey = Date.toDateKeyString(from: selectedDate)
    
    guard let dailyData = state.monthHistoryData[dateKey] else { return }
    guard let record = dailyData.records.first(where: { $0.productId == state.selectedProductID }) else { return }
    //      let result = try await beverageUseCase.deleteBeverage(productID: state.selectedProductID , intakeTime: dailyData.date)
    print("🗓️ \(dateKey),\(dailyData.date), 🥤 \(record.beverageName)")
    
    do {
      let result = try await beverageUseCase.deleteBeverage(productID: state.selectedProductID, intakeTime: dailyData.date)
      
      if (result) {
        print("❌ 삭제 \(result) 성공")
      } else {
        print("❌ 삭제 \(result) 실패")
      }
    } catch {
      print("❌ 네트워크 삭제 실패: \(error)")
    }
  }
  
  
  private func resetSelectedData() {
    state.selectedDateHistoryList = []
    state.totalSugarGrams = 0
    state.totalCount = 0
    clearSelectedProductID()
  }
  
  private func clearSelectedProductID() {
    state.selectedProductID = ""
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
    resetSelectedData()
    
    guard let selectedDate = state.selectedDate else { return }
    
    let dateKey = Date.toDateKeyString(from: selectedDate)
    guard let dailyData = state.monthHistoryData[dateKey] else { return }
    
    // 유효한 데이터 있으면 세팅
    state.totalSugarGrams = dailyData.totalSugarGrams
    state.totalCount = dailyData.records.count
    state.selectedDateHistoryList = dailyData.records
  }
}

