//
//  NotificationSettingViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import UIKit
import Combine

import CommonFeature
import UserDomain
import DesignSystem
import Shared

import Dependencies

@Observable
@MainActor
public final class NotificationSettingViewModel: ViewModelable {
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  @ObservationIgnored
  @Dependency(\.notificationClient) private var notificationClient
  
  private var cancellables = Set<AnyCancellable>()
  private var didOpenSettings = false
  
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
    var showPermissionDeniedAlert: Bool = false
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
    case onDisappear
    case loadUserInfo
    case openSystemSettings
    case dismissAlert
    case dismissPermissionDeniedAlert
    case appDidBecomeActive
    
    case toggleIsEnabled(Bool)
    case toggleRemindersEnabled(Bool)
    case toggleRiskWarningsEnabled(Bool)
    case toggleCaffeineNotification(Bool)
    case updateReminderTime(Date)
  }
  
  public init(userID: String) {
    let initialState = State(userID: userID)
    self.state = initialState
    setupAppLifecycleObservers()
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleAction(.loadUserInfo)
      
    case .onDisappear:
      cleanup()
      
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
      
    case .dismissPermissionDeniedAlert:
      state.showPermissionDeniedAlert = false
      
    case .appDidBecomeActive:
      // 설정에서 돌아온 경우에만 권한 재확인
      if didOpenSettings {
        Task {
          await handleReturnFromSettings()
        }
      }
      
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
  private func setupAppLifecycleObservers() {
    NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
      .sink { [weak self] _ in
        Task { @MainActor in
          self?.handleAction(.appDidBecomeActive)
        }
      }
      .store(in: &cancellables)
  }
  
  private func cleanup() {
    cancellables.removeAll()
    didOpenSettings = false
  }
  
  private func handleReturnFromSettings() async {
    didOpenSettings = false
    
    await checkSystemNotificationPermission()
    
    if !state.systemPermissionGranted {
      state.showPermissionDeniedAlert = true

      if state.notiInfo.isEnabled {
        await updateUseNotiInfo(isEnabled: false)
      }
    }
  }
  
  private func loadUserData() async {
    guard !state.isLoading else { return }
    
    setLoading(true)
    
    do {
      let result = try await userUseCase.getUserNotificationInfo(userID: state.userID)
      
      if !state.systemPermissionGranted && result.isEnabled {
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
    let isNotDetermined = await notificationClient.isNotDetermined()
    let isAuthorized = !isNotDetermined

    await MainActor.run {
      state.systemPermissionGranted = isAuthorized

      print("알림 권한 미결정 여부: \(isNotDetermined)")
      print("권한 허용됨: \(isAuthorized)")
    }
  }
  
  private func openSystemSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    
    if UIApplication.shared.canOpenURL(settingsUrl) {
      didOpenSettings = true
      UIApplication.shared.open(settingsUrl) { success in
        if !success {
          Task { @MainActor in
            self.didOpenSettings = false
          }
        }
      }
    }
  }
  
  private func updateNotiSetting(_ settingType: NotiSettingType) async {
    
    if !state.systemPermissionGranted {
      switch settingType {
      case .isEnabled(let isEnabled):
        if isEnabled {
          await requestNotificationPermission()
        } else {
          await updateUseNotiInfo(isEnabled: false)
        }
        return
        
      case .remindersEnabled(let isEnabled),
           .riskWarningsEnabled(let isEnabled),
           .newsUpdatesEnabled(let isEnabled):
        if isEnabled {
          state.showPermissionAlert = true
          return
        }
        
      case .reminderTime(_):
        state.showPermissionAlert = true
        return
      }
    }
    
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
  
  private func requestNotificationPermission() async {
    do {
      let granted = try await notificationClient.requestAuthorization()

      await notificationClient.registerForRemoteNotifications()

      await checkSystemNotificationPermission()

      if granted {
        await updateUseNotiInfo(isEnabled: true)
      } else {
        state.showPermissionAlert = true
      }
    } catch {
      print("❌ 알림 권한 요청 실패: \(error)")
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
