//
//  NotificationSettingViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation
import UserDomain
import CommonFeature

@Observable
@MainActor
public final class NotificationSettingViewModel: ViewModelable {
  
  public struct State: Equatable {
    // 알림 설정
    var isPermissionGranted: Bool
    var isGoalReminderEnabled: Bool
    var reminderTime = Date()
    var isGoalWarningEnabled: Bool
    var isCaffeineNotificationEnabled: Bool
    var showTimePicker: Bool = false
  }
  
  public enum Action {
    case onAppear
    
    // 알림 토글 액션
    case toggleGeneralNotification(Bool)
    case toggleGoalReminder(Bool)
    case toggleGoalWarning(Bool)
    case toggleCaffeineNotification(Bool)
    
    // 시간 설정 액션
    case updateReminderTime(Date)
    
    case updateNotificationSettingInfo
  }
  
  public var state: State
  private var originalState: State
  
  public init() {
    let initialState = State(
      isPermissionGranted: false,
      isGoalReminderEnabled: false,
      reminderTime: Self.defaultReminderTime(),
      isGoalWarningEnabled: false,
      isCaffeineNotificationEnabled: false
    )
    
    self.state = initialState
    self.originalState = initialState
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .toggleGeneralNotification(let isEnabled):
      state.isPermissionGranted = isEnabled
      
    case .toggleGoalReminder(let isEnabled):
      state.isGoalReminderEnabled = isEnabled
      
    case .toggleGoalWarning(let isEnabled):
      state.isGoalWarningEnabled = isEnabled
      
    case .toggleCaffeineNotification(let isEnabled):
      state.isCaffeineNotificationEnabled = isEnabled
      
    case .updateReminderTime(let time):
      state.reminderTime = time
    
    case .updateNotificationSettingInfo:
      break
    }
  }
  
  public func getReminderTimeString() -> String {
      return UserNotifications.reminderTimeFormatter.string(from: state.reminderTime)
  }
}

extension NotificationSettingViewModel {
  
  private static func defaultReminderTime() -> Date {
    var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    comps.hour = 12; comps.minute = 0; comps.second = 0
    return Calendar.current.date(from: comps) ?? Date()
  }
  
  public var isChangedNotificationSettings: Bool {
    return state != originalState
  }
  
  public var needsNotificationPermission: Bool {
    return false
  }
  
  public var isOtherNotificationsEnabled: Bool {
    return state.isPermissionGranted
  }
}
