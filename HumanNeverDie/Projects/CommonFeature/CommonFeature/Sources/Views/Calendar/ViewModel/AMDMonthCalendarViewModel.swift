//
//  AMDMonthCalendarViewModel.swift
//  CommonFeature
//
//  Created by Seulki Lee on 6/30/25.
//

import SwiftUI

@Observable
class AMDMonthCalendarViewModel: AMDCommonCalendarViewModel {
  var currentMonth: Int = 0
  var dayModels: [CalendarDayModel] = []
  
  override init(
    currentDate: Date,
    sugarIntakeRecordData: [SugarIntakeRecord],
    userSugarTargetValue: Int
  ) {
    super.init(
      currentDate: currentDate,
      sugarIntakeRecordData: sugarIntakeRecordData,
      userSugarTargetValue: userSugarTargetValue
    )
    
    updateDayModels()
  }
  
  var MonthTitleDateString: String {
    titleDateString(titleDate: currentDate)
  }
  
  func getCurrentMonth() -> Date {
    calendar.date(byAdding: .month, value: currentMonth, to: currentDate) ?? currentDate
  }
  
  func updateCurrentDateToCurrentMonth() {
    updateCurrentDate(to: getCurrentMonth())
    currentMonth = 0
  }
  
  func extractDate() -> [DateValue] {
    let currentMonth = getCurrentMonth()
    
    var days = currentMonth.getAllDates(using: calendar).compactMap { date -> DateValue in
      let day = calendar.component(.day, from: date)
      
      return DateValue(day: day, date: date)
    }
    
    let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
    for _ in 0..<firstWeekday - 1 {
      days.insert(DateValue(day: -1, date: Date()), at: 0)
    }
    return days
  }
  
  func handleDragGesture(_ translation: CGSize) {
    if translation.width < -dragThreshold {
      moveMonth(by: 1)
    } else if translation.width > dragThreshold {
      moveMonth(by: -1)
    }
  }
  
  func moveMonth(by offset: Int) {
    withAnimation {
      currentMonth += offset
      updateDayModels()
    }
  }
  
  func updateDayModels() {
    let extracted = extractDate()
    dayModels = extracted.map { value in
      CalendarDayModel(
        value: value,
        isToday: isToday(value.date),
        isSelected: isSelected(value.date),
        textColor: textColor(for: value.date),
        stateIcon: matchingValue(for: value.date).map { getStateIcon(for: $0) }
      )
    }
  }
}

extension Date {
  func getAllDates(using calendar: Calendar) -> [Date] {
    let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    let range = calendar.range(of: .day, in: .month, for: startDate)!
    
    return range.compactMap { day -> Date in
      return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
    }
  }
}
