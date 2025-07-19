//
// SettingViewModel.swift
// Setting
//
// Created by Seulki Lee on 2025.
//
import Foundation
import Shared
import UserDomain
import CommonFeature

@Observable
@MainActor
public final class SettingViewModel: ViewModelable {
  
  public struct State: Equatable {
    var userInfo: UserInfo
  }
  
  public enum Action {
    case onAppear
    case loadUserInfo // 서버에서 데이터 로드
  }
  
  public var state: State
  
  public init() {
    // 초기값 설정 (서버에서 불러올 예정, 현재는 더미 데이터)
    self.state = State(userInfo: UserInfo.defaultUserInfo) // 또는 UserInfo.defaultUserInfo
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      handleAction(.loadUserInfo)
      
    case .loadUserInfo:
      // TODO: 실제로는 서버에서 데이터를 가져옴
      // 현재는 더미 데이터 사용
      state.userInfo = UserInfo.defaultUserInfo
    }
  }
}

// MARK: - Public Methods for Navigation
extension SettingViewModel {
  // AccountInfo 화면으로 넘겨줄 UserInfo
  public func getUserInfoForAccountSetting() -> UserInfo {
    return state.userInfo
  }
  
  // GoalSetting 화면으로 넘겨줄 UserInfo
  public func getUserInfoForGoalSetting() -> UserInfo {
    return state.userInfo
  }
}
