//
//  AMDCommonCalendarViewModel.swift
//  CommonFeature
//
//  Created by Seulki Lee on 6/30/25.
//

import SwiftUI

class AMDCommonCalendarViewModel {
  private var selectedDate: Date? = nil
  private(set) var currentDate: Date
  private let sugarIntakeRecordData: [SugarIntakeRecord]
  private let userSugarTargetValue: Int
  let calendar = Calendar.current
  let dragThreshold: CGFloat = 50
  let weekdayItems: [AMDWeekdayTile] = AMDWeekdayTile.allCases
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible()), count: weekdayItems.count)
  }
  
  init(currentDate: Date, sugarIntakeRecordData: [SugarIntakeRecord], userSugarTargetValue: Int) {
    self.currentDate = currentDate
    self.sugarIntakeRecordData = sugarIntakeRecordData
    self.userSugarTargetValue = userSugarTargetValue
  }
  
  func updateCurrentDate(to date : Date) {
    currentDate = date
  }
  
  func titleDateString(titleDate : Date) -> String {
    DateFormatter.calendarTitleFormat.string(from: titleDate)
  }
  
  func getStateIcon(for value: Int) -> Image? {
    let sugerValue = Double(value) / Double(userSugarTargetValue) * 100
    return AMDStateIcon(percentage: sugerValue).icon
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
  
  func isUpdateForSelectedDate(_ date: Date) -> Bool{
    if (selectedDate == date) { return false }
    
    updateCurrentDate(to: date)
    selectDate(date)
    return true
  }
}

extension DateFormatter {
  static let calendarTitleFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    return formatter
  }()
}
