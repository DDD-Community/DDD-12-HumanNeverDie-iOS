//
// HomeViewModel.swift
// Home
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
public final class HomeViewModel: ViewModelable {
  public struct State: Equatable {
    var isViewDidLoad: Bool = false
    
    var currentDate: Date = Date()
    var selectedDate: Date? = Date()
    
    var sugarIntakeRecords: [SugarIntakeRecord] = []
    var weeklyHistories: [String: BeverageCalendar] = [:]
    
    var baseSugar: Int = 50
    var selectedDateCalendar: BeverageCalendar?
    var isSelectedDateEmpty: Bool = true
    
    var isMonthPickerPresented: Bool = false
    
    var isTodayOrPastSelectedDate: Bool { selectedDate.isTodayOrPastSelectedDate }
  }
  
  var sugarStatus: BeverageSugarStatusType {
    let totalSugar = state.selectedDateCalendar?.totalSugarGrams ?? 0
    return .init(baseSugar: state.baseSugar, totalSugar: totalSugar)
  }
  
  public enum Action {
    case onViewDidLoad
    /// 캘린더 헤더 Date 뷰 선택
    case calendarChangeDateButtonTapped
    /// 캘린더의 날짜 선택 시
    case updateSelectedDate(Date?)
    /// 캘린더 좌우 주간 스와이프 시
    case weekSlideGesture(Date)
    /// 날짜 피커에서 날짜 선택 완료
    case datePickerConfirmed(Date)
    /// 음료 기록 완료
    case homeRefresh
  }
  
  @ObservationIgnored
  @Dependency(\.beverageUseCase) private var beverageUseCase
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onViewDidLoad:
      guard !state.isViewDidLoad else { return }
      state.isViewDidLoad = true
      
      Task { await getWeeklyCalender() }
      
    case .calendarChangeDateButtonTapped:
      state.isMonthPickerPresented = true
      
    case let .updateSelectedDate(date):
      state.selectedDate = date
      updateSelectedDateCalendar()
      
    case let .weekSlideGesture(date):
      state.currentDate = date
      Task { await getWeeklyCalender() }
      
    case let .datePickerConfirmed(date):
      state.isMonthPickerPresented = false
      
      state.currentDate = date
      state.selectedDate = date
      Task { await getWeeklyCalender() }
      
    case .homeRefresh:
      Task { await getWeeklyCalender() }
    }
  }
  
  private func getWeeklyCalender() async {
    do {
      let dateString = Date.toRequestDateKeyString(from: state.currentDate)
      let result = try await beverageUseCase.getBeverageWeeklyCalender(dateInWeek: dateString)
      
      state.baseSugar = result[0].sugarMaxG
      let newSugarIntakeRecordData: [SugarIntakeRecord] = result.compactMap { dailyData in
        let dateKey = dailyData.date.toYMDFormat
        state.weeklyHistories[dateKey] = dailyData
        
        guard let date = String.toDate(from: dailyData.date) else { return nil }
        
        return SugarIntakeRecord(
          date: date,
          value: dailyData.totalSugarGrams
        )
      }
      
      await MainActor.run {
        state.sugarIntakeRecords = newSugarIntakeRecordData
        updateSelectedDateCalendar()
      }
    } catch {
      print("주간 데이터 로드 실패: \(error)")
    }
  }
  
  private func updateSelectedDateCalendar() {
    guard let selectedDate = state.selectedDate else {
      state.selectedDateCalendar = nil
      return
    }
    
    let dateKey = Date.toDateKeyString(from: selectedDate)
    state.selectedDateCalendar = state.weeklyHistories[String(dateKey)]
    
    if let selectedDateCalendar = state.selectedDateCalendar {
      state.isSelectedDateEmpty = selectedDateCalendar.records.isEmpty
      
      Task {
        await userDefaultClient.setValue(selectedDateCalendar.totalSugarGrams, forKey: AMDUserDefaultKey.totalSugar)
        await userDefaultClient.setValue(selectedDateCalendar.sugarMaxG, forKey: AMDUserDefaultKey.baseSugar)
      }
    } else {
      state.isSelectedDateEmpty = true
    }
  }
}
