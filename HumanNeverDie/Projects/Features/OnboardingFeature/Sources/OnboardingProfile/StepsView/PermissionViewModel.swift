//
//  PermissionViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 8/20/25.
//

import Foundation

import CommonFeature
import DesignSystem
import Shared

import Dependencies

@Observable
@MainActor
public final class PermissionViewModel: ViewModelable {
  private weak var parentViewModel: OnboardingProfileViewModel?
  
  public struct State: Equatable {
    var userID: String = ""
    
    var isPermissionRequested: Bool = false
    var isPermissionCompleted: Bool = false
  }
  
  public enum Action {
    case onAppear
    case requestPermission
    case completeOnboarding
  }
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  @ObservationIgnored
  @Dependency(\.keychainClient) private var keychainClient
  
  @ObservationIgnored
  @Dependency(\.notificationClient) private var notificationClient
  
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  
  public var state: State = .init()
  
  public init(parentViewModel: OnboardingProfileViewModel) {
    self.parentViewModel = parentViewModel
    
    if let userID = keychainClient.getValue(forKey: AMDKeychainKey.userID) {
      state.userID = userID
    }
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      if !state.isPermissionRequested {
        handleAction(.requestPermission)
      }
      
    case .requestPermission:
      Task {
        await requestNotificationPermission()
        await MainActor.run {
          state.isPermissionCompleted = true
        }
      }
      
    case .completeOnboarding:
      parentViewModel?.handleAction(.completeOnboarding)
    }
  }
  
  // MARK: - Private Methods
  private func requestNotificationPermission() async {
    state.isPermissionRequested = true
    
    do {
      let granted = try await notificationClient.requestAuthorization()
      
      await notificationClient.registerForRemoteNotifications()
      
      if !granted {
        await showPermissionDeniedAlert()
      }
      
      _ = try await userUseCase.updateNotifications(userID: state.userID, isEnabled: granted)
    } catch {
      printIfDebug("❌ notification Register 실패 \(error)")
    }
  }
}

// MARK: - Public Interface
extension PermissionViewModel {
  public var canCompleteOnboarding: Bool {
    return state.isPermissionRequested
  }
}

extension PermissionViewModel {
  private func showPermissionDeniedAlert() async {
    let alertProperty = AMDAlertProperty(
      title: "알람이 거부되었어요",
      message: "알림을 다시 받으려면 앱 설정에서 허용해야해요.",
      primaryButton: .init(
        title: "닫기",
        type: .secondary,
        action: {}
      )
    )
    
    Task { @MainActor in
      await alertClient.showAlert(alertProperty)
    }
  }
}
