//
//  AMDCalendarViewModel.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/25/25.
//

import SwiftUI

final class AMDCalendarViewModel: ObservableObject {
  @Published private(set) var currentMonth: Int = 0
  @Published private var selectedDate: Date? = nil
  @Published private var currentDate: Date //월간 사용
  @Published private var currentWeekStartDate: Date = Date().startOfWeek() //주간 사용
  private let calendar = Calendar.current
  private let sugarIntakeRecordData: [SugarIntakeRecord]
  private let userSugarTargetValue: Int
  private let dragThreshold: CGFloat = 50
  
  
  init(currentDate: Date, sugarIntakeRecordData: [SugarIntakeRecord], userSugarTargetValue : Int) {
    self.currentDate = currentDate
    self.currentWeekStartDate = currentDate.startOfWeek()
    self.sugarIntakeRecordData = sugarIntakeRecordData
    self.userSugarTargetValue = userSugarTargetValue
  }
  
  var titleDateString: String {
    DateFormatter.calendarTitleFormat.string(from: currentDate)
  }

  let weekdayItems: [AMDWeekdayTile] = AMDWeekdayTile.allCases
  
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible()), count: weekdayItems.count)
  }
  
  func getCurrentMonth() -> Date {
    calendar.date(byAdding: .month, value: currentMonth, to: currentDate) ?? currentDate
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
  
  func getStateIcon(for value: Int) -> Image {
    let sugerValue = Double(value) / Double(userSugarTargetValue) * 100
    return AMDStateIcon(percentage: sugerValue).icon
  }
  
  func handleDragGesture(_ translation: CGSize) {
    if translation.width < -50 {
      moveMonth(by: 1)
    } else if translation.width > 50 {
      moveMonth(by: -1)
    }
  }

  func moveMonth(by offset: Int) {
    withAnimation {
      currentMonth += offset
    }
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
  
//Week사용 함수
  var weekTitleDateString: String {
    DateFormatter.calendarTitleFormat.string(from: currentWeekStartDate)
  }
  
  func getCurrentWeekDates() -> [DateValue] {
    (0..<7).compactMap { offset in
      guard let date = calendar.date(byAdding: .day, value: offset, to: currentWeekStartDate) else {
        return nil
      }

      let day = calendar.component(.day, from: date)
      return DateValue(day: day, date: date)
    }
  }

  func moveWeek(by weeks: Int) {
    if let newWeek = calendar.date(byAdding: .weekOfYear, value: weeks, to: currentWeekStartDate) {
      currentWeekStartDate = newWeek
    }
  }
  
  func getWeekCalendarDay(from date: Date) -> Int {
    calendar.component(.day, from: date)
  }
  
  func handleWeekDragGesture(_ translation: CGSize) {
    if translation.width < -dragThreshold {
      moveWeek(by: 1)
    } else if translation.width > dragThreshold {
      moveWeek(by: -1)
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
  
  func startOfWeek(using calendar: Calendar = .current) -> Date {
    let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
    return calendar.date(from: components)!
  }
}

extension DateFormatter {
  static let calendarTitleFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    return formatter
  }()
}
