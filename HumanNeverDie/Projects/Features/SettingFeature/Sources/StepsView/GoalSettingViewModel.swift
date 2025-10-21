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
  private var router: Router?
  
  public struct State: Equatable, Sendable {
    var userInfo: UserInfo
    var selectedDailySugarGoal: SugarGoal
    var isShowingSugarCalculationInfo: Bool = false
    var userSugarLevel: UserSugarLevel? = nil
  }
  
  public enum Action {
    case onAppear
    case updateDailySugarGoal(SugarGoal)
    case updateAccountInfoUserInfo
    case showSugarCalculationInfo
    case hideSugarCalculationInfo
  }
  
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
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
      Task {
        await loadUserSugarLevel()
      }
      
    case .updateDailySugarGoal(let sugarGoal):
      state.selectedDailySugarGoal = sugarGoal
      
    case .updateAccountInfoUserInfo:
      Task {
        await showSaveAlert()
      }
      break
    case .showSugarCalculationInfo:
      state.isShowingSugarCalculationInfo = true
      
    case .hideSugarCalculationInfo:
      state.isShowingSugarCalculationInfo = false
    }
  }
}

// MARK: - Goal Setting Specific Methods
extension GoalSettingViewModel {
  public func setRouter(_ router: Router) {
    self.router = router
  }
  
  private func loadUserSugarLevel() async {
    let userSugarLevel = await userUseCase.getUserSugarLavel(userID: "")
    await MainActor.run {
      state.userSugarLevel = userSugarLevel
    }
  }

  public func getSugarGoalAmount(for goal: SugarGoal) -> Int {
    guard let userSugarLevel = state.userSugarLevel else { 
      return getSugarGoalAmountFromPreviousData(for: goal)
    }
    
    switch goal {
    case .easy:
      return userSugarLevel.data.easy.sugarMaxG
    case .normal:
      return userSugarLevel.data.normal.sugarMaxG
    case .hard:
      return userSugarLevel.data.hard.sugarMaxG
    case .none:
      return 0
    }
  }
  
  private func getSugarGoalAmountFromPreviousData(for goal: SugarGoal) -> Int {
    guard state.userInfo.selectedDailySugarGoal == .easy else { return 0 }
    
    switch goal {
    case .easy:
      return state.userInfo.sugarMaxG
    case .normal:
      return state.userInfo.sugarMaxG / 2
    case .hard:
      return state.userInfo.sugarMaxG / 5
    case .none:
      return 0
    }
  }
  
  public var normalSugarAmount: Int {
    return getSugarGoalAmount(for: .easy)
  }
  
  public var isChangedAccountInfo: Bool {
    if (state.isShowingSugarCalculationInfo) {
      return false
    }
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
            self.router?.popWithResult(updatedUserInfo)
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
