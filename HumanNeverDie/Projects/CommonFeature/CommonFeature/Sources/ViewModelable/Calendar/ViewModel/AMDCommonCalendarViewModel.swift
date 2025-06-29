//
//  AMDCommonCalendarViewModel.swift
//  CommonFeature
//
//  Created by Seulki Lee on 6/30/25.
//

import SwiftUI

class AMDCommonCalendarViewModel: ObservableObject {
  @Published public var currentMonth: Int = 0
  @Published private var selectedDate: Date? = nil
  @Published public var currentDate: Date
  @Published private var currentWeekStartDate: Date = Date().startOfWeek() //주간 사용
  let calendar = Calendar.current
  let sugarIntakeRecordData: [SugarIntakeRecord]
  let userSugarTargetValue: Int
  let dragThreshold: CGFloat = 50
  
  init(currentDate: Date, sugarIntakeRecordData: [SugarIntakeRecord], userSugarTargetValue: Int) {
    self.currentDate = currentDate
    self.sugarIntakeRecordData = sugarIntakeRecordData
    self.userSugarTargetValue = userSugarTargetValue
  }

  let weekdayItems: [AMDWeekdayTile] = AMDWeekdayTile.allCases
  
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible()), count: weekdayItems.count)
  }
  
  func titleDateString(titleDate : Date) -> String {
    DateFormatter.calendarTitleFormat.string(from: titleDate)
  }
  
  func getCurrentMonth() -> Date {
    calendar.date(byAdding: .month, value: currentMonth, to: currentDate) ?? currentDate
  }
  
  func getStateIcon(for value: Int) -> Image {
    let sugerValue = Double(value) / Double(userSugarTargetValue) * 100
    return AMDStateIcon(percentage: sugerValue).icon
  }

  
  func updateCurrentDateToCurrentMonth() {
    currentDate = getCurrentMonth()
    currentMonth = 0
  }
  
  func isToday(_ date: Date) -> Bool {
    calendar.isDateInToday(date)
  }

  func isSelected(_ date: Date) -> Bool {
    guard let selected = selectedDate else { return false }
    return calendar.isDate(selected, inSameDayAs: date)
  }

  func matchingValue(for date: Date) -> Int? {
    sugarIntakeRecordData.first { calendar.isDate($0.date, inSameDayAs: date) }?.value
  }

  func textColor(for date: Date) -> Color {
    let weekday = calendar.component(.weekday, from: date)
    return AMDWeekdayTile(weekday).color
  }
  
  func selectDate(_ date: Date) {
    selectedDate = date
  }
  
}

extension DateFormatter {
  static let calendarTitleFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    return formatter
  }()
}
