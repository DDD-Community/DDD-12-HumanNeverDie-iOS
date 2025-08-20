//
//  AMDWeekCalendarViewModel.swift
//  CommonFeature
//
//  Created by Seulki Lee on 6/30/25.
//

import SwiftUI

@Observable
class AMDWeekCalendarViewModel: AMDCommonCalendarViewModel {
  private var currentWeekStartDate: Date = Date().startOfWeek()
  private(set) var dayModels: [CalendarDayModel] = []
  
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
    
    self.currentWeekStartDate = currentDate.startOfWeek()
    updateDayModels()
  }
  
  var weekTitleDateString: String {
    titleDateString(titleDate: currentWeekStartDate)
  }
  
  func extractDate() -> [DateValue] {
    (0..<7).compactMap { offset in
      guard let date = calendar.date(byAdding: .day, value: offset, to: currentWeekStartDate) else {
        return nil
      }
      
      let day = calendar.component(.day, from: date)
      return DateValue(day: day, date: date)
    }
  }
  
  func handleDragGesture(_ translation: CGSize) {
    if translation.width < -dragThreshold {
      moveWeek(by: 1)
    } else if translation.width > dragThreshold {
      moveWeek(by: -1)
    }
  }
  
  func moveWeek(by weeks: Int) {
    if let newWeek = calendar.date(byAdding: .weekOfYear, value: weeks, to: currentWeekStartDate) {
      currentWeekStartDate = newWeek
      updateDayModels()
    }
  }
  
  func applySelectedDate(_ date: Date) {
    if (isUpdateForSelectedDate(date)) {
      self.currentWeekStartDate = currentDate.startOfWeek()
      updateDayModels()
    }
  }
  
  func updateDayModels() {
      let extracted = extractDate()
      dayModels = extracted.map { value in
        let dateWithCurrentTime = value.date.applyingCurrentTime()
       
        return CalendarDayModel(
          value: DateValue(day: value.day, date: dateWithCurrentTime),
          isToday: isToday(dateWithCurrentTime),
          isSelected: isSelected(dateWithCurrentTime),
          textColor: textColor(for: dateWithCurrentTime),
          stateIcon: matchingValue(for: dateWithCurrentTime).flatMap { getStateIcon(for: $0) }
        )
      }
  }

  
  func updateSugarIntakeData(_ newData: [SugarIntakeRecord]) {
    self.sugarIntakeRecordData = newData
    updateDayModels()
  }
  
  func getCurrentWeekStartDate() -> Date {
    return currentWeekStartDate
  }
}

extension Date {
  func startOfWeek(using calendar: Calendar = .current) -> Date {
    let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
    return calendar.date(from: components)!
  }
  
  func applyingCurrentTime() -> Date {
    let calendar = Calendar.current
    let now = Date()
    
    var dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
    let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: now)
    
    dateComponents.hour = timeComponents.hour
    dateComponents.minute = timeComponents.minute
    dateComponents.second = timeComponents.second
    
    return calendar.date(from: dateComponents)!
  }
}

