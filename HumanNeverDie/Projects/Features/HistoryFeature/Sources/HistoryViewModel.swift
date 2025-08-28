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
import DesignSystem
import Shared

import Dependencies

@Observable
@MainActor
public final class HistoryViewModel: ViewModelable {
  public struct State: Equatable {
    var isViewDidLoad: Bool = false
    
    var currentDate: Date = Date()
    var selectedDate: Date? = Date()
    
    var selectedIntakeHistoryID: String = ""
    var selectedProductID: String = ""
    var isMonthPickerPresented = false
    var isListPopupPresented: Bool { !selectedProductID.isEmpty }
    var isBevarageDetailPresented = false
    
    var isLoading: Bool = false
    
    var selectedDateHistoryList: [BeverageCalendarRecoders] = []
    var sugarIntakeRecordData: [SugarIntakeRecord] = []
    var monthHistoryData: [String: BeverageCalendar] = [:]
    
    var baseSugar: Int = 50
    var selectedDateCalendar: BeverageCalendar?
    
    var totalSugarGrams = 0
    var totalCount = 0
    
    var isTodayOrPastSelectedDate: Bool { selectedDate.isTodayOrPastSelectedDate }

    var sugarStatus: BeverageSugarStatusType {
      let totalSugar = selectedDateCalendar?.totalSugarGrams ?? 0
      return .init(baseSugar: baseSugar, totalSugar: totalSugar)
    }
  }
  
  public enum Action {
    case onAppear
    case historyRefresh
    case beverageListFavoriteTapped(Bool, String)
    case beverageListInfoTapped
    case loadHistorDailyList
    case loadHistoryForSelectedDate
    case datePickeronConfirm
    case updateCurrentDate(Date)
    case updateSelectedProductID( String, String)
    case updateisMonthPickerPresented(Bool)
    case applySelectedDate(Date)
    case clearSelectedBeverage
    case deleteSelectedBeverage
    case beverageRecordButtonTapped
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
  @ObservationIgnored
  @Dependency(\.globalState) private var globalState
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      state.selectedDate = Date.now
 
      guard !state.isViewDidLoad else { return }
      state.isViewDidLoad = true
      
      Task { await refreshData() }
      
    case .loadHistorDailyList, .datePickeronConfirm, .historyRefresh:
      Task { await refreshData() }
      
    case .beverageListFavoriteTapped(_, _):
      break
      
    case .beverageListInfoTapped:
      state.isBevarageDetailPresented = true
      
    case .loadHistoryForSelectedDate:
      print("selectedDate:\(state.selectedDate)")
      
      loadSelectedDateHistory()
      
    case .updateCurrentDate(let newDate):
      state.currentDate = newDate
      
    case .updateSelectedProductID(let intakeHistoryId,let productId):
      state.selectedIntakeHistoryID = intakeHistoryId
      state.selectedProductID = productId
      
    case .clearSelectedBeverage:
      clearSelectedItemID()
      
    case .updateisMonthPickerPresented(let isPickerPresented):
      state.isMonthPickerPresented = isPickerPresented
      
    case .applySelectedDate(let newDate):
      state.currentDate = newDate
      state.selectedDate = newDate
      state.isMonthPickerPresented = false
      
    case .deleteSelectedBeverage:
      Task {
        await showDeleteAlert()
      }
      
    case .beverageRecordButtonTapped:
      Task {
        let dateKey = Date.toDateKeyString(from: state.selectedDate ?? Date())
        guard let dailyData = state.monthHistoryData[dateKey] else { return }
        
        await userDefaultClient.setValue(dailyData.totalSugarGrams, forKey: AMDUserDefaultKey.totalSugar)
        await userDefaultClient.setValue(dailyData.sugarMaxG, forKey: AMDUserDefaultKey.baseSugar)
      }
    }
  }
}

extension HistoryViewModel {
  
  func getSelectedDateString() -> String {
    if let selected = state.selectedDate {
      return Date.toDateTitleString(from: selected)
    } else {
      return ""
    }
  }
  
  private func refreshData() async {
    await loadNetworkData()
    loadSelectedDateHistory()
  }
  
  nonisolated private func showDeleteAlert() async {
    await alertClient.showAlert(.init(
      title: "이 기록을 삭제할까요?",
      message: "삭제하면 복구할 수 없어요.",
      primaryButton: .init(title: "삭제", type: .delete) {
        await self.deleteSelectedBeverage()
      },
      secondaryButton: .init(title: "취소", type: .secondary) {
        await self.clearSelectedItemID()
      }
    ))
  }
  
  private func deleteSelectedBeverage() async {
    guard let selectedRecord = state.selectedDateHistoryList.first(where: {
      String($0.productId) == state.selectedProductID
    }) else { return }
    
    do {
      let result = try await beverageUseCase.deleteBeverage(
        productID: state.selectedProductID,
        intakeTime: selectedRecord.intakeTime
      )
      
      if result {
        await globalState.sendEvent(.homeRefresh)
        showToast(message: "삭제가 완료되었어요.", type: .success)
        clearSelectedItemID()
        await refreshData()
      } else {
        showToast(message: "데이터를 삭제할 수 없습니다.", type: .failure)
      }
    } catch {
      showToast(message: "네트워크의 문제로 실패하였습니다.", type: .failure)
    }
  }
  
  private func showToast(message: String, type: AMDToastType) {
    Task { @MainActor in
      await toastClient.showToast(.init(message: message, type: type))
    }
  }

  private func resetSelectedData() {
    state.selectedDateHistoryList = []
    state.totalSugarGrams = 0
    state.totalCount = 0
    clearSelectedItemID()
  }
  
  private func clearSelectedItemID() {
    state.selectedProductID = ""
    state.selectedIntakeHistoryID = ""
  }
  
  private func loadNetworkData() async {
    guard !state.isLoading else { return }
    
    state.isLoading = true
    state.monthHistoryData.removeAll()
    
    do {
      let dateString = Date.toRequestDateKeyString(from:state.currentDate)
      let result = try await beverageUseCase.getBeverageMonthCalender(dateInWeek: dateString)

      state.baseSugar = result[0].sugarMaxG
      let newSugarIntakeRecordData: [SugarIntakeRecord] = result.compactMap { dailyData in
        
        state.selectedDateCalendar = dailyData
        
        let dateKey = dailyData.date.toYMDFormat
        state.monthHistoryData[dateKey] = dailyData
        let recordCount = dailyData.records.count
        
        guard let date = String.toDate(from: dailyData.date) else { return nil }
        return SugarIntakeRecord(date: date, value: dailyData.totalSugarGrams, recordCount:recordCount)
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
    
    state.totalSugarGrams = dailyData.totalSugarGrams
    state.totalCount = dailyData.records.count
    state.selectedDateHistoryList = dailyData.records
  }
}

