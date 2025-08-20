//
//  PermissionViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 8/20/25.
//

import Foundation
import UserNotifications
import CommonFeature

@Observable
@MainActor
public final class PermissionViewModel: ViewModelable {
  private weak var parentViewModel: OnboardingProfileViewModel?
  
  public struct State: Equatable {
    var isPermissionGranted: Bool = false
    var isPermissionRequested: Bool = false
  }
  
  public enum Action {
    case onAppear
    case requestPermission
    case completeOnboarding
  }
  
  public var state: State = .init()
  
  public init(parentViewModel: OnboardingProfileViewModel) {
    self.parentViewModel = parentViewModel
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      if !state.isPermissionRequested {
        handleAction(.requestPermission)
      }
      
    case .requestPermission:
      Task { await requestNotificationPermission() }
      
    case .completeOnboarding:
      parentViewModel?.handleAction(.completeOnboarding)
    }
  }
  
  // MARK: - Private Methods
  private func requestNotificationPermission() async {
    state.isPermissionRequested = true
    
    let center = UNUserNotificationCenter.current()
    
    do {
      let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
      
      await MainActor.run {
        state.isPermissionGranted = granted
      }
      
      await parentViewModel?.updateNotificationSetting(isEnabled: granted)
      
    } catch {
      await MainActor.run {
        state.isPermissionGranted = false
      }
      
      await parentViewModel?.updateNotificationSetting(isEnabled: false)
    }
  }
}

// MARK: - Public Interface
extension PermissionViewModel {
  public var canCompleteOnboarding: Bool {
    return state.isPermissionRequested
  }
}
