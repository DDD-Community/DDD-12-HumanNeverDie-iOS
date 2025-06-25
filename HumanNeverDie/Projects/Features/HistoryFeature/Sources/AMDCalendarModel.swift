//
//  AMDCalendarModel.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/25/25.
//

import SwiftUI
import DesignSystem

public struct SugarIntakeRecord {
  let date: Date
  let value: Int
}

struct WeekdayValue: Identifiable {
  let id = UUID()
  let label: String
  let color: Color
}

struct DateValue: Identifiable {
  var id: UUID = UUID()
  var day: Int
  var date : Date
}

final class AMDCalendarViewModel: ObservableObject {
  @Published var currentMonth: Int = 0
  @Published private var selectedDate: Date? = nil
  @Published private var currentDate: Date
  private let calendar = Calendar.current
  private let sugarIntakeRecordData: [SugarIntakeRecord]
  private let userSugarTargetValue: Int
  
  init(currentDate: Date, sugarIntakeRecordData: [SugarIntakeRecord], userSugarTargetValue : Int) {
    self.currentDate = currentDate
    self.sugarIntakeRecordData = sugarIntakeRecordData
    self.userSugarTargetValue = userSugarTargetValue
  }
  
  var titleDateString: String {
    DateFormatter.calendarTitleFormat.string(from: currentDate)
  }

  private static let titleFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    return formatter
  }()

  var weekdayItems: [WeekdayValue] {
    let weekdayLabels = ["일", "월", "화", "수", "목", "금", "토"]
    
    return weekdayLabels.enumerated().map { index, weekday in
      let weekdayIndex = index + 1 // Sunday = 1, Saturday = 7
      return WeekdayValue(label: weekday, color: weekdayColor(weekdayIndex))
    }
  }
  
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible()), count: weekdayItems.count)
  }
  
  func getCurrentMonth() -> Date {
    calendar.date(byAdding: .month, value: currentMonth, to: Date()) ?? Date()
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
  
  func weekdayColor(_ weekday: Int) -> Color {
    switch weekday {
    case 1: return Color.redDarker
    case 7: return Color.primaryDarker
    default: return Color.gray80
    }
  }
  
  func getStateIcon(for value: Int) -> Image {
    let percentage = Double(value) / Double(userSugarTargetValue) * 100
    
    if percentage <= 33 {
      return AMDImage.stateHealthy.swiftUIImage
    } else if percentage <= 66 {
      return AMDImage.stateWarning.swiftUIImage
    } else {
      return AMDImage.stateDanger.swiftUIImage
    }
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
    if isSelected(date) && weekday != 1 && weekday != 7 {
      return Color.gray100
    } else {
      return weekdayColor(weekday)
    }
  }
  
  func selectDate(_ date: Date) {
    selectedDate = date
    currentDate = date
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

extension DateFormatter {
  static let calendarTitleFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    return formatter
  }()
}
