//
//  UserNotifications.swift
//  UserDomain
//
//  Created by Seulki Lee on 8/14/25.
//

import SwiftUI

public struct UserNotifications: Equatable, Sendable {
    public let isPermissionGranted: Bool
    public let isGoalReminderEnabled: Bool
    public let reminderTime: String
    public let isGoalWarningEnabled: Bool
    public let isCaffeineNotificationEnabled: Bool

    public init(
        isPermissionGranted: Bool,
        isGoalReminderEnabled: Bool,
        reminderTime: String, // ← 여전히 문자열을 받음
        isGoalWarningEnabled: Bool,
        isCaffeineNotificationEnabled: Bool
    ) {
        self.isPermissionGranted = isPermissionGranted
        self.isGoalReminderEnabled = isGoalReminderEnabled
      self.reminderTime = reminderTime
        self.isGoalWarningEnabled = isGoalWarningEnabled
        self.isCaffeineNotificationEnabled = isCaffeineNotificationEnabled
    }

 public static let defaultUserNotifications = UserNotifications(
        isPermissionGranted: false,
        isGoalReminderEnabled: false,
        reminderTime: "오후 12시 10분",
        isGoalWarningEnabled: false,
        isCaffeineNotificationEnabled: false
    )

  public static let reminderTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter
    }()
}


public extension UserNotifications {
  static func mock() -> UserNotifications {
    UserNotifications.defaultUserNotifications
  }
}
