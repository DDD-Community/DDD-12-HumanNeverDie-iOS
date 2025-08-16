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
    var isEnabled: Bool = false
    var remindersEnabled: Bool = false
    var reminderTime : Date = Date.now
    var riskWarningsEnabled: Bool = false
    var newsUpdatesEnabled: Bool = false
    var showTimePicker: Bool = false
    var isLoading: Bool = false
    
    var userNotificationSettingInfo: UserNotifications = UserNotifications.mock()
  }
  
  public enum Action {
    case onAppear
    case loadUserInfo
    
    // 알림 토글 액션
    case toggleIsEnabled(Bool)
    case toggleRemindersEnabled(Bool)
    case toggleRiskWarningsEnabled(Bool)
    case toggleCaffeineNotification(Bool)
    
    // 시간 설정 액션
    case updateReminderTime(Date)
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
      
      
    case .toggleIsEnabled(let isEnabled):
      state.isEnabled = isEnabled
      
    case .toggleRemindersEnabled(let isEnabled):
      state.remindersEnabled = isEnabled
      
    case .toggleRiskWarningsEnabled(let isEnabled):
      state.riskWarningsEnabled = isEnabled
      
    case .toggleCaffeineNotification(let isEnabled):
      state.newsUpdatesEnabled = isEnabled
      
    case .updateReminderTime(let time):
      state.reminderTime = time

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
      state.isEnabled = result.isEnabled
      state.remindersEnabled = result.remindersEnabled
      state.reminderTime = result.convertTimeStringToDate(result.reminderTime)
      state.riskWarningsEnabled = result.riskWarningsEnabled
      state.newsUpdatesEnabled = result.newsUpdatesEnabled
      
      state.isLoading = false
      
    } catch {
      print("❌ 유저 정보 로딩 실패: \(error)")
      state.isLoading = false
    }
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
}
