//
//  NotificationSettingViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation
import UserDomain
import CommonFeature

import Dependencies

@Observable
@MainActor
public final class NotificationSettingViewModel: ViewModelable {
  public struct State: Equatable {
    
    let userID: String
    var isPermissionGranted: Bool = false
    var isGoalReminderEnabled: Bool = false
    var reminderTime : Date = Date.now
    var isGoalWarningEnabled: Bool = false
    var isCaffeineNotificationEnabled: Bool = false
    var showTimePicker: Bool = false
    var isLoading: Bool = false
    
    var userNotificationSettingInfo: UserNotifications = UserNotifications.mock()
  }
  
  public enum Action {
    case onAppear
    case loadUserInfo
    
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
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  public init(userID: String) {
    let initialState = State(userID: userID)
    
    self.state = initialState
    self.originalState = initialState
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleAction(.loadUserInfo)
      
    case .loadUserInfo:
      Task {
        await loadUserData()
      }
      
      
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
  private func loadUserData() async {
    guard !state.isLoading else { return }
    
    state.isLoading = true
    
    do {
      let result = try await userUseCase.getUserNotificationInfo(userID: state.userID)
      state.userNotificationSettingInfo = result
      state.isPermissionGranted = result.isPermissionGranted
      state.isGoalWarningEnabled = result.isGoalWarningEnabled
      state.isGoalReminderEnabled = result.isGoalReminderEnabled
      state.reminderTime = convertTimeStringToDate(result.reminderTime)
      state.isGoalWarningEnabled = result.isGoalWarningEnabled
      state.isCaffeineNotificationEnabled = result.isCaffeineNotificationEnabled
      
      
      state.isLoading = false
      
    } catch {
      print("❌ 유저 정보 로딩 실패: \(error)")
      state.isLoading = false
    }
  }
  
  private func convertTimeStringToDate(_ timeString: String) -> Date {
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
