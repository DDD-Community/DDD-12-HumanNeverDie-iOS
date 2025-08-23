//
//  NotificationSettingViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation
import UserNotifications
import UserDomain
import UIKit

import DesignSystem
import CommonFeature

import Dependencies

@Observable
@MainActor
public final class NotificationSettingViewModel: ViewModelable {
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  private enum NotiSettingType {
    case isEnabled(Bool)
    case remindersEnabled(Bool)
    case riskWarningsEnabled(Bool)
    case newsUpdatesEnabled(Bool)
    case reminderTime(Date)
  }
  
  public struct State: Equatable {
    let userID: String
    var showTimePicker: Bool = false
    var isLoading: Bool = false
    var notiInfo: UserNotifications = UserNotifications.mock()

    var systemPermissionGranted: Bool = false
    var showPermissionAlert: Bool = false
  }
  
  public var state: State
  public var isEnabled: Bool { return state.notiInfo.isEnabled }
  public var remindersEnabled: Bool { return state.notiInfo.remindersEnabled }
  public var reminderTime: Date { return state.notiInfo.convertTimeStringToDate(state.notiInfo.reminderTime) }
  public var reminderTimeString: String { return UserNotifications.reminderTimeFormatter.string(from: reminderTime) }
  public var riskWarningsEnabled: Bool { return state.notiInfo.riskWarningsEnabled }
  public var newsUpdatesEnabled: Bool { return state.notiInfo.newsUpdatesEnabled }
  
  public enum Action {
    case onAppear
    case loadUserInfo
    case openSystemSettings
    case dismissAlert
    
    case toggleIsEnabled(Bool)
    case toggleRemindersEnabled(Bool)
    case toggleRiskWarningsEnabled(Bool)
    case toggleCaffeineNotification(Bool)
    case updateReminderTime(Date)
  }
  
  public init(userID: String) {
    let initialState = State(userID: userID)
    self.state = initialState
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleAction(.loadUserInfo)
      
    case .loadUserInfo:
      Task {
        await checkSystemNotificationPermission()
        await loadUserData()
      }
      
    case .openSystemSettings:
      openSystemSettings()
      state.showPermissionAlert = false
      
    case .dismissAlert:
      state.showPermissionAlert = false
      
    case .toggleIsEnabled(let isEnabled):
      Task {
        await updateNotiSetting(.isEnabled(isEnabled))
      }
      
    case .toggleRemindersEnabled(let isEnabled):
      Task {
        await updateNotiSetting(.remindersEnabled(isEnabled))
      }
      
    case .toggleRiskWarningsEnabled(let isEnabled):
      Task {
        await updateNotiSetting(.riskWarningsEnabled(isEnabled))
      }
      
    case .toggleCaffeineNotification(let isEnabled):
      Task {
        await updateNotiSetting(.newsUpdatesEnabled(isEnabled))
      }
      
    case .updateReminderTime(let time):
      Task {
        await updateNotiSetting(.reminderTime(time))
      }
      state.showTimePicker = false
    }
  }
}

extension NotificationSettingViewModel {
  private func loadUserData() async {
    guard !state.isLoading else { return }
    
    setLoading(true)
    
    do {
      let result = try await userUseCase.getUserNotificationInfo(userID: state.userID)
      if (!state.systemPermissionGranted && result.isEnabled) {
        await updateUseNotiInfo(isEnabled: false)
      } else {
        state.notiInfo = result
      }
  
      setLoading(false)
      
    } catch {
      print("❌ 노티 정보 로딩 실패: \(error)")
      
      setLoading(false)
    }
  }
  
  nonisolated private func checkSystemNotificationPermission() async {
    let center = UNUserNotificationCenter.current()
    let settings = await center.notificationSettings()
    let isAuthorized = settings.authorizationStatus == .authorized
    
    await MainActor.run {
      state.systemPermissionGranted = isAuthorized
    }
  }
  
  private func openSystemSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      showToast(message: "설정을 열 수 없습니다.", type: .failure)
      return
    }
    
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.open(settingsUrl) { [weak self] success in
        if success {
          // 설정에서 돌아왔을 때 권한 상태 다시 확인
          Task { @MainActor in
            await self?.checkSystemNotificationPermission()
          }
        }
      }
    } else {
      showToast(message: "설정을 열 수 없습니다.", type: .failure)
    }
  }
  
  private func updateNotiSetting(_ settingType: NotiSettingType) async {
    if (state.systemPermissionGranted == false) {
      state.showPermissionAlert = true
    }else {
      
      var current = state.notiInfo
      
      switch settingType {
      case .isEnabled(let isEnabled):
        await updateUseNotiInfo(isEnabled: isEnabled)
        return
        
      case .remindersEnabled(let isEnabled):
        current.remindersEnabled = isEnabled
        
      case .riskWarningsEnabled(let isEnabled):
        current.riskWarningsEnabled = isEnabled
        
      case .newsUpdatesEnabled(let isEnabled):
        current.newsUpdatesEnabled = isEnabled
        
      case .reminderTime(let time):
        current.reminderTime = current.convertDateToTimeString(time)
      }
      
      await updateNotiInfo(notiInfo: current)
    }
  }
  
  private func updateUseNotiInfo(isEnabled: Bool) async {
    setLoading(true)
    
    do {
      let result = try await userUseCase.updateNotifications(userID: state.userID, isEnabled: isEnabled)
      state.notiInfo = result
      
      setLoading(false)
      
    } catch {
      showToast(message: "오류가 발생했어요. 다시 시도해주세요.", type: .failure)
      
      setLoading(false)
    }
  }
  
  private func updateNotiInfo(notiInfo: UserNotifications) async {
    setLoading(true)
    
    do {
      let result = try await userUseCase.updateUserNotifications(userID: state.userID, userNotifications: notiInfo)
      state.notiInfo = result
      
      setLoading(false)
      
    } catch {
      showToast(message: "오류가 발생했어요. 다시 시도해주세요.", type: .failure)
      
      setLoading(false)
    }
  }
  
  func setLoading(_ isLoading: Bool) {
    state.isLoading = isLoading
  }
  
  private func showToast(message: String, type: AMDToastType) {
    Task { @MainActor in
      await toastClient.showToast(.init(message: message, type: type))
    }
  }
}
