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
import AuthDomain
import CommonFeature
import DesignSystem

import Dependencies

@Observable
@MainActor
public final class SettingViewModel: ViewModelable {
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  
  public struct State: Equatable {
    var userInfo: UserInfo
    var isLoading: Bool = false
    var userID: String = ""
    var isLogoutAndWithdrawal: Bool = false
    
    var sugarMaxG: Int = 0
  }
  
  public enum Action {
    case onAppear
    case updateUserInfo(UserInfo)
    case logout
    case logoutAlertButtonTapped
    case unsubscribe
    case withdrawalAlertButtonTapped
    
  }
  
  public var state: State
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  @ObservationIgnored
  @Dependency(\.authUseCase) private var authUseCase
  @ObservationIgnored
  @Dependency(\.keychainClient) private var keychainClient
  
  public init() {
    self.state = State(userInfo: UserInfo.defaultUserInfo)
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      if let userID = keychainClient.getValue(forKey: AMDKeychainKey.userID) {
        state.userID = userID
      }
      
      Task { await loadUserData()}
      
    case .updateUserInfo(let userInfo):
      Task { await updateUserInfo(userInfo: userInfo) }
      
    case .logout:
      Task { await showLogoutAlert() }
      
    case .logoutAlertButtonTapped:
      Task { await logout() }
      
    case .unsubscribe:
      Task {
        await showUnsubscribeAlert()
      }
      
    case .withdrawalAlertButtonTapped:
      Task { await withdraw() }
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
      setUserInfo(userInfo: result)
      state.sugarMaxG = result.sugarMaxG
      
    } catch {
      showToast(message: "저장에 실패하였습니다", type: .failure)
      state.isLoading = false
    }
  }
  
  private func logout() async {
    do {
      _ = try await authUseCase.logout()
      
      await MainActor.run {
        state.isLogoutAndWithdrawal = true
      }
    } catch {
      showToast(message: "로그아웃에 실패했습니다", type: .failure)
    }
  }
  
  private func withdraw() async {
    do {
      _ = try await authUseCase.withdraw()
      
      await MainActor.run {
        state.isLogoutAndWithdrawal = true
      }
    } catch {
      showToast(message: "회원 탈퇴에 실패했습니다", type: .failure)
    }
  }
  
  private func setUserInfo(userInfo: UserInfo) {
    state.userInfo = userInfo
    
    let sugarService = SugarUserCalculation()
    let userSugerMaxG = sugarService.calculateUserSugarGoal(for: userInfo)
    
    print("서버 = \(state.sugarMaxG) == \(userSugerMaxG)")
    state.sugarMaxG = userSugerMaxG
    
  }
  
  nonisolated private func showLogoutAlert() async {
    await alertClient.showAlert(
      .init(
        title: "정말 로그아웃 하시겠습니까?",
        primaryButton: .init(title: "로그아웃", type: .delete) { [weak self] in
          await self?.handleAction(.logoutAlertButtonTapped)
        }
      )
    )
  }
  
  nonisolated private func showUnsubscribeAlert() async {
    await alertClient.showAlert(.init(
      title: "정말 탈퇴하시겠어요?",
      message: "탈퇴시 아래 정보가 모두 사라지며, 재가입해도 복구할 수 없어요.\n\n• 계정 및 개인 정보\n• 개인 당류 섭취 기록 및 히스토리",
      primaryButton: .init(title: "취소", type: .secondary) {
        //취소
      },
      secondaryButton: .init(title: "탈퇴하기", type: .delete) { [weak self] in
        await self?.handleAction(.withdrawalAlertButtonTapped)
      }
    ))
  }
  
  private func showToast(message: String, type: AMDToastType) {
    Task { @MainActor in
      await toastClient.showToast(.init(message: message, type: type))
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
