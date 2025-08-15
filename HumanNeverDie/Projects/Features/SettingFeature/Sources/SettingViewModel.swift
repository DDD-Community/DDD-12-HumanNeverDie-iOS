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
import DesignSystem

import Dependencies

@Observable
@MainActor
public final class SettingViewModel: ViewModelable {
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  
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
    
    var sugarMaxG: Int = 0
  }
  
  public enum Action {
    case onAppear
    case loadUserInfo
    case navigateTo(CurrentView)
    case goBack
    case updateUserInfo(UserInfo)
    
  }
  
  public var state: State
  
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
      
    case .updateUserInfo(let userInfo): // 추가
      Task {
        await updateUserInfo(userInfo: userInfo)
      }
    }
  }
}

// MARK: - Private Methods
extension SettingViewModel {
  
  private func loadUserData() async {
    state.isLoading = true
    
    do {
      let result = try await userUseCase.getUserInfo(userID: state.userID)
      setUserInfo(userInfo: result)
      state.isLoading = false
      
    } catch {
      print("❌ 유저 정보 로딩 실패: \(error)")
      state.isLoading = false
    }
  }
  
  private func updateUserInfo(userInfo : UserInfo) async {
    state.isLoading = true
    
    do {
      let result = try await userUseCase.updateUserInfo(userID: state.userID, userInfo: userInfo)
      
      showToast(message: "저장이 완료되었어요", type: .success)
      setUserInfo(userInfo: result.toUserInfo())
      state.sugarMaxG = result.sugarMaxG
      
    } catch {
      showToast(message: "저장에 실패하였습니다", type: .failure)
      state.isLoading = false
    }
  }
  
  private func showToast(message: String, type: AMDToastType) {
    Task { @MainActor in
      await toastClient.showToast(.init(message: message, type: type))
    }
  }

  private func setUserInfo(userInfo: UserInfo) {
    state.userInfo = userInfo
    
    let sugarService = SugarUserCalculation()
    let userSugerMaxG = sugarService.calculateUserSugarGoal(for: userInfo)
    
    print("서버 = \(state.sugarMaxG) == \(userSugerMaxG)")
    state.sugarMaxG = userSugerMaxG
  
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
