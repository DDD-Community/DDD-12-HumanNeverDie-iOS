//
//  NotificationSettingViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation
import UserDomain

import DesignSystem
import CommonFeature

import Dependencies

@Observable
@MainActor
public final class NotificationSettingViewModel: ViewModelable {
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  
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
      Task {
        await setIsEnabledWithUserInfo(isEnabled: isEnabled)
      }
    
    case .toggleRemindersEnabled(let isEnabled):
      Task {
        await setRemindersEnabledWithUserInfo(isEnabled: isEnabled)
      }
      
    case .toggleRiskWarningsEnabled(let isEnabled):
      Task {
        await setRiskWarningsEnabledWithUserInfo(isEnabled: isEnabled)
      }
      
    case .toggleCaffeineNotification(let isEnabled):
      Task {
        await setNewsUpdatesEnabledWithUserInfo(isEnabled: isEnabled)
      }
      
    case .updateReminderTime(let time):
      Task {
        await setReminderTimeWithUserInfo(time: time)
      }
      state.showTimePicker = false
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
      print("❌ 노티 정보 로딩 실패: \(error)")
      state.isLoading = false
    }
  }

  public var isChangedNotificationSettings: Bool {
    return state != originalState
  }
  
  public var needsNotificationPermission: Bool {
    return false
  }
}

extension NotificationSettingViewModel {
  private func setIsEnabledWithUserInfo(isEnabled: Bool) async {
    let current = UserNotifications(
        isEnabled: isEnabled,
        remindersEnabled: isEnabled,
        reminderTime: state.userNotificationSettingInfo.reminderTime,
        riskWarningsEnabled: isEnabled,
        newsUpdatesEnabled: isEnabled
    )
    
    await updateUserNotificationsInfo(userNotificationsInfo: current)
  }
  
  private func setRemindersEnabledWithUserInfo(isEnabled: Bool) async {
    var current = state.userNotificationSettingInfo
    current.remindersEnabled = isEnabled
    
    await updateUserNotificationsInfo(userNotificationsInfo: current)
  }
  
  private func setRiskWarningsEnabledWithUserInfo(isEnabled: Bool) async {
    var current = state.userNotificationSettingInfo
    current.riskWarningsEnabled = isEnabled
    
    await updateUserNotificationsInfo(userNotificationsInfo: current)
  }
  
  private func setNewsUpdatesEnabledWithUserInfo(isEnabled: Bool) async {
    var current = state.userNotificationSettingInfo
    current.newsUpdatesEnabled = isEnabled
    
    await updateUserNotificationsInfo(userNotificationsInfo: current)
  }
  
  private func setReminderTimeWithUserInfo(time: Date) async {
    var current = state.userNotificationSettingInfo
    current.reminderTime = current.convertDateToTimeString(time)
    
    await updateUserNotificationsInfo(userNotificationsInfo: current)
  }
  
  private func updateUserNotificationsInfo(userNotificationsInfo: UserNotifications) async {
    state.isLoading = true
    
    do {
      let result = try await userUseCase.updateUserNotifications(userID: state.userID, userNotifications: userNotificationsInfo)
      
      updateNorifications(updatedNotificationInfo: result)
      state.isLoading = false
      
    } catch {
      showToast(message: "오류가 발생했어요. 다시 시도해주세요.", type: .failure)
      state.isLoading = false
    }
  }
  
  private func showToast(message: String, type: AMDToastType) {
    Task { @MainActor in
      await toastClient.showToast(.init(message: message, type: type))
    }
  }
  
  
  private func updateNorifications(updatedNotificationInfo: UserNotifications) {
    state.isEnabled = updatedNotificationInfo.isEnabled
    state.remindersEnabled = updatedNotificationInfo.remindersEnabled
    state.reminderTime = updatedNotificationInfo.convertTimeStringToDate(updatedNotificationInfo.reminderTime)
    state.riskWarningsEnabled = updatedNotificationInfo.riskWarningsEnabled
    state.newsUpdatesEnabled = updatedNotificationInfo.newsUpdatesEnabled

    state.userNotificationSettingInfo = updatedNotificationInfo
  }

  
}
