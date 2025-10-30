//
// LoginViewModel.swift
// Auth
//
// Created by 김규철 on 2025.
//

import Foundation
import Observation

import AuthDomain
import CommonFeature
import DesignSystem
import Shared

import Dependencies

@Observable
@MainActor
public final class LoginViewModel: ViewModelable {
  public struct State: Equatable {
    var isLoading: Bool = false
    var route: RootRoute?
    
    // 알림
    var isNotDetermined: Bool = false
    var requestAuthorization: Bool = false
  }
  
  public enum Action {
    case onAppear
    case loginButtonTapped
  }
  
  @ObservationIgnored
  @Dependency(\.authUseCase) private var authUseCase
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  @ObservationIgnored
  @Dependency(\.notificationClient) private var notificationClient
  
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task.detached { [weak self] in
        await self?.checkNotification()
      }
      
    case .loginButtonTapped:
      Task.detached { [weak self] in
        await self?.loginWithApple()
      }
    }
  }
  
  private func loginWithApple() async {
    await MainActor.run {
      state.isLoading = true
    }
    
    do {
      let userInfo = try await authUseCase.loginWithApple()
      
      if state.isNotDetermined && !userInfo.isFirstLogin {
        _ = try await userUseCase.updateNotifications(userID: userInfo.userID, isEnabled: state.requestAuthorization)
      }
      
      await MainActor.run {
        state.isLoading = false
        state.route = userInfo.isFirstLogin ? .onboarding : .main
      }
    } catch {
      await MainActor.run {
        state.isLoading = false
      }
            
      await toastClient.showToast(
        AMDToastProperty(
          message: error.localizedDescription,
          type: .failure
        )
      )
    }
  }
  
  private func checkNotification() async {
    do {
      let isNotDetermined = await notificationClient.isNotDetermined()
      await MainActor.run { state.isNotDetermined = isNotDetermined }

      if isNotDetermined {
        let requestAuthorization = try await notificationClient.requestAuthorization()
        await MainActor.run { state.requestAuthorization = requestAuthorization }
      }
      
      await notificationClient.registerForRemoteNotifications()
    } catch {
      printIfDebug("❌ notification Register 실패 \(error)")
    }
  }
}
