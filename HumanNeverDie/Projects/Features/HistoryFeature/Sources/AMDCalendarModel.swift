//
//  AMDCalendarModel.swift
//  HistoryFeature
//
//  Created by Seulki Lee on 6/25/25.
//

import SwiftUI
import DesignSystem

struct WeekdayInfo: Identifiable {
  let id = UUID()
  let name: String
  let color: Color
}

struct DateValue: Identifiable {
  var id: UUID = UUID()
  var day: Int
  var date : Date
}

final class AMDCalendarViewModel: ObservableObject {
  @Published var currentMonth: Int = 0
  @Published var currentDate: Date
  @Published var selectedDate: Date? = nil
  let valueByDate: [Date: Int]
  let defaultValue: Int
  
  init(currentDate: Date, valueByDate: [Date: Int], defaultValue : Int) {
    self.currentDate = currentDate
    self.valueByDate = valueByDate
    self.defaultValue = defaultValue
  }
  
  var days: [String] {
    ["일", "월", "화", "수", "목", "금", "토"]
  }
  
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible()), count: days.count)
  }
  
  func getCurrentMonth() -> Date {
    Calendar.current.date(byAdding: .month, value: currentMonth, to: Date()) ?? Date()
  }
  
  func extractDate() -> [DateValue] {
    let calendar = Calendar.current
    
    let currentMonth = getCurrentMonth()
    
    var days = currentMonth.getAllDates().compactMap { date -> DateValue in
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
    let percentage = Double(value) / Double(defaultValue) * 100
    
    if percentage <= 33 {
      return AMDImage.stateHealthy.swiftUIImage
    } else if percentage <= 66 {
      return AMDImage.stateWarning.swiftUIImage
    } else {
      return AMDImage.stateDanger.swiftUIImage
    }
  }
  
  func extraDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    return formatter.string(from: currentDate)
  }
}

