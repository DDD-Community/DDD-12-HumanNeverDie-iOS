//
// SettingViewModel.swift
// Setting
//
// Created by Seulki Lee on 2025.
//
import Foundation
import Observation

import Shared
import UserDomain
import CommonFeature

import Dependencies

@Observable
@MainActor
public final class SettingViewModel: ViewModelable {
  
  public enum CurrentView {
    case main
    case accountInfo
    case goalSetting
    case Notification
  }
  
  public struct State: Equatable {
    var userInfo: UserInfo
    var isLoading: Bool = false
    var currentView: CurrentView = .main
    let userID: String = "b5219141-afe3-46c6-8c5c-0f7e850a5bef"
  }
  
  public enum Action {
    case onAppear
    case loadUserInfo
    case navigateTo(CurrentView)
    case goBack
  }
  
  public var state: State
  
  // 편의 프로퍼티
  public var currentView: CurrentView { state.currentView }
  public var userInfo: UserInfo { state.userInfo }
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  public init() {
    self.state = State(userInfo: UserInfo.defaultUserInfo)
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleAction(.loadUserInfo)
      
    case .loadUserInfo:
      Task {
        await loadUserData()
      }
      
    case .navigateTo(let view):
      state.currentView = view
      
    case .goBack:
      state.currentView = .main
    }
  }
}

// MARK: - Private Methods
extension SettingViewModel {
  
  private func loadUserData() async {
    guard !state.isLoading else { return }
    
    state.isLoading = true
    
    do {
      let result = try await userUseCase.getUserInfo(userID: state.userID)
      state.userInfo = result
      state.isLoading = false
      
    } catch {
      print("❌ 유저 정보 로딩 실패: \(error)")
      state.isLoading = false
    }
  }
}

// MARK: - Public Methods for Navigation
extension SettingViewModel {
  
  public func getUserInfoForAccountSetting() -> UserInfo {
    return state.userInfo
  }
  
  public func getUserInfoForGoalSetting() -> UserInfo {
    return state.userInfo
  }
}
