//
//  GoalSettingViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation

import Shared
import UserDomain
import CommonFeature

import Dependencies

@Observable
@MainActor
public final class GoalSettingViewModel: ViewModelable {
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  private var router: Router?
  
  public struct State: Equatable, Sendable {
    var userInfo: UserInfo
    var selectedDailySugarGoal: SugarGoal
  }
  
  public enum Action {
    case onAppear
    case updateDailySugarGoal(SugarGoal)
    
    case updateAccountInfoUserInfo
  }
  
  public var state: State
  private var originalState: State
  
  public init(
    userInfo: UserInfo
  ) {
    let initialState = State(
      userInfo: userInfo,
      selectedDailySugarGoal: userInfo.selectedDailySugarGoal
    )
    
    self.state = initialState
    self.originalState = initialState
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .updateDailySugarGoal(let sugarGoal):
      state.selectedDailySugarGoal = sugarGoal
      
    case .updateAccountInfoUserInfo:
      Task {
        await showSaveAlert()
      }
      break
    }
  }
}

// MARK: - Goal Setting Specific Methods
extension GoalSettingViewModel {
  public func setRouter(_ router: Router) {
      self.router = router
  }
  
  public func getSugarGoalAmount(for goal: SugarGoal) -> Int {
    // 임시로 목표를 변경한 userInfo 생성
    let tempUserInfo = UserInfo(
      nickname: state.userInfo.nickname,
      birthDate: state.userInfo.birthDate,
      selectedGender: state.userInfo.selectedGender,
      height: state.userInfo.height,
      weight: state.userInfo.weight,
      selectedActivity: state.userInfo.selectedActivity,
      selectedDailySugarGoal: goal
    )
    
    return sugarGoalCalculator(userInfo:tempUserInfo)
  }
  
  public var normalSugarAmount: Int {
    return getSugarGoalAmount(for: .easy)
  }
  
  public var isChangedAccountInfo: Bool {
    return state != originalState
  }
  
  public var isValidDailySugarGoal: Bool {
    return state.selectedDailySugarGoal != .none
  }
  
  nonisolated private func showSaveAlert() async {
      await alertClient.showAlert(.init(
        title: "목표를 정말 변경하시겠어요?",
        message: "목표 설정 수정 시, 일일 당 섭취 목표가 즉시 변경될 예정이에요.",
        primaryButton: .init(title: "저장", type: .default) {
          Task { @MainActor in
            // 🔵 수정: UserInfo 전체를 새로 생성해서 전달
            let updatedUserInfo = UserInfo(
              nickname: self.state.userInfo.nickname,
              birthDate: self.state.userInfo.birthDate,
              selectedGender: self.state.userInfo.selectedGender,
              height: self.state.userInfo.height,
              weight: self.state.userInfo.weight,
              selectedActivity: self.state.userInfo.selectedActivity,
              selectedDailySugarGoal: self.state.selectedDailySugarGoal
            )
            
            await MainActor.run {
              self.router?.onUserInfoUpdated?(updatedUserInfo)
              self.router?.pop()
            }
          }
        },
        secondaryButton: .init(title: "취소", type: .secondary) {
          // 취소 시 원래 값으로 되돌리기
          Task { @MainActor in
            self.state.selectedDailySugarGoal = self.originalState.selectedDailySugarGoal
          }
        }
      ))
    }
}
