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

@Observable
@MainActor
public final class GoalSettingViewModel: ViewModelable {
  
  public struct State: Equatable {
    var nickname: String = ""
    var selectedDailySugarGoal: SugarGoal = .none
  }
  
  public enum Action {
    case onAppear
    case updateAccountInfoUserInfo
    case updateDailySugarGoal(SugarGoal)
  }
  
  public var state: State = .init()
  private var originalState: State
  
  public init(userInfo: UserInfo) {
    let initialState = State(
      nickname : userInfo.nickname,
      selectedDailySugarGoal: userInfo.selectedDailySugarGoal
    )
    
    self.state = initialState
    self.originalState = initialState
  }
  
  public func initWithSugarGoal(sugarGoal: SugarGoal) {
    let initialState = State(selectedDailySugarGoal: sugarGoal)
    
    self.state = initialState
    self.originalState = initialState
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .updateAccountInfoUserInfo:
      break
      
    case .updateDailySugarGoal(let sugarGoal):
      state.selectedDailySugarGoal = sugarGoal
    }
  }
}

// MARK: - Goal Setting Specific Methods
extension GoalSettingViewModel {
  public var isChangedAccountInfo: Bool {
    return state != originalState
  }
  
  public var isValidDailySugarGoal: Bool {
    return UserInfoValidator.isValidDailySugarGoal(state.selectedDailySugarGoal)
  }
}
