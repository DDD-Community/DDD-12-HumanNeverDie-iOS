//
//  UserInfo.swift
//  CommonFeature
//
//  Created by Seulki Lee on 7/23/25.
//

import SwiftUI

public struct UserInfo: Equatable {
    public let nickname: String
    public let birthDate: String
    public let selectedGender: Gender
    public let height: String
    public let weight: String
    public let selectedActivity: ActivityLevel
    public let selectedDailySugarGoal: SugarGoal
    public let isPermissionGranted: Bool
    public let isGoalReminderEnabled: Bool
    public let reminderTime: Date
    public let isGoalWarningEnabled: Bool
    public let isCaffeineNotificationEnabled: Bool

    public init(
        nickname: String,
        birthDate: String,
        selectedGender: Gender,
        height: String,
        weight: String,
        selectedActivity: ActivityLevel,
        selectedDailySugarGoal: SugarGoal,
        isPermissionGranted: Bool,
        isGoalReminderEnabled: Bool,
        reminderTime: String, // ← 여전히 문자열을 받음
        isGoalWarningEnabled: Bool,
        isCaffeineNotificationEnabled: Bool
    ) {
        self.nickname = nickname
        self.birthDate = birthDate
        self.selectedGender = selectedGender
        self.height = height
        self.weight = weight
        self.selectedActivity = selectedActivity
        self.selectedDailySugarGoal = selectedDailySugarGoal
        self.isPermissionGranted = isPermissionGranted
        self.isGoalReminderEnabled = isGoalReminderEnabled
      self.reminderTime = UserInfo.reminderTimeFormatter.date(from: reminderTime) ?? Date()
        self.isGoalWarningEnabled = isGoalWarningEnabled
        self.isCaffeineNotificationEnabled = isCaffeineNotificationEnabled
    }

  nonisolated(unsafe) public static let defaultUserInfo = UserInfo(
        nickname: "",
        birthDate: "",
        selectedGender: .none,
        height: "",
        weight: "",
        selectedActivity: .none,
        selectedDailySugarGoal: .none,
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
