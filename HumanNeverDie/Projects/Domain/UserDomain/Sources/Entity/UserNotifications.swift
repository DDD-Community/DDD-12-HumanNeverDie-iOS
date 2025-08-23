//
//  UserNotifications.swift
//  UserDomain
//
//  Created by Seulki Lee on 8/14/25.
//

import SwiftUI

public struct UserNotifications: Equatable, Sendable {
  public var isEnabled: Bool
  public var remindersEnabled: Bool
  public var reminderTime: String
  public var riskWarningsEnabled: Bool
  public var newsUpdatesEnabled: Bool
  
  public init(
    isEnabled: Bool,
    remindersEnabled: Bool,
    reminderTime: String,
    riskWarningsEnabled: Bool,
    newsUpdatesEnabled: Bool
  ) {
    self.isEnabled = isEnabled
    self.remindersEnabled = remindersEnabled
    self.reminderTime = reminderTime
    self.riskWarningsEnabled = riskWarningsEnabled
    self.newsUpdatesEnabled = newsUpdatesEnabled
  }
  
}

public extension UserNotifications {
  static func mock() -> UserNotifications {
    UserNotifications.defaultUserNotifications(isEnabled: false)
  }
}

extension UserNotifications {
  
  public static func defaultUserNotifications(
    isEnabled: Bool = false,
    remindersEnabled: Bool? = nil,
    reminderTime: String = "15:00:00",
    riskWarningsEnabled: Bool? = nil,
    newsUpdatesEnabled: Bool? = nil
  ) -> UserNotifications {
    return UserNotifications(
      isEnabled: isEnabled,
      remindersEnabled: remindersEnabled ?? isEnabled,
      reminderTime: reminderTime,
      riskWarningsEnabled: riskWarningsEnabled ?? isEnabled,
      newsUpdatesEnabled: newsUpdatesEnabled ?? isEnabled
    )
  }
  
  public static let reminderTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "a h시 mm분"
    return formatter
  }()
  
  public func convertTimeStringToDate(_ timeString: String) -> Date {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm:ss"
    
    let calendar = Calendar.current
    let today = Date()
    
    if let timeDate = timeFormatter.date(from: timeString) {
      let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: timeDate)
      
      if let finalDate = calendar.date(bySettingHour: timeComponents.hour ?? 0,
                                       minute: timeComponents.minute ?? 0,
                                       second: timeComponents.second ?? 0,
                                       of: today) {
        return finalDate
      }
    }
    
    return defaultReminderTime()
  }
  
  private func defaultReminderTime() -> Date {
    var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    comps.hour = 12
    comps.minute = 0
    comps.second = 0
    return Calendar.current.date(from: comps) ?? Date()
  }
  
  public func convertDateToTimeString(_ date: Date) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm:ss"
      return formatter.string(from: date)
  }
}
