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
    //AccountInfoView
    var nickname: String = ""
    var birthDate: String = ""
    var selectedGender: Gender = .none
    var height: String = ""
    var weight: String = ""
    var selectedActivity: ActivityLevel = .none
    
    //DailySugarGoalView
    var selectedDailySugarGoal: SugarGoal = .none
    
    //PermissionView
    var isPermissionGranted: Bool = false
  }
  
  public enum Action {
    case onAppear
    
    // AccountInfoView
    case updateNickname(String)
    case updateBirthDate(String)
    case updateGender(Gender)
    case updateHeight(String)
    case updateWeight(String)
    case updateActivity(ActivityLevel)
    
    case updateAccountInfoUserInfo
    
    case updateDailySugarGoal(SugarGoal)
  }
  
  public var state: State = .init()
  private var originalState: State

  public init() {
    // 초기값 설정 (예: 서버에서 불러온 사용자 정보)
    let initialState = State(
      nickname: "아맞당",
      birthDate: "2025-07-25",
      selectedGender: .female,
      height: "150",
      weight: "50",
      selectedActivity: .low,
      selectedDailySugarGoal: .normal,
      isPermissionGranted: false
    )
    
    self.state = initialState
    self.originalState = initialState
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
    case .updateNickname(let nickname):
      state.nickname = nickname
      
    case .updateBirthDate(let birthDate):
      state.birthDate = birthDate
      
    case .updateGender(let gender):
      state.selectedGender = gender
      
    case .updateHeight(let height):
      state.height = height
      
    case .updateWeight(let weight):
      state.weight = weight
      
    case .updateActivity(let activity):
      state.selectedActivity = activity
      
    case .updateAccountInfoUserInfo:
      break
      
    case .updateDailySugarGoal(let activity):
      state.selectedDailySugarGoal = activity
    }
  }
}

//AccountInfoView
extension SettingViewModel {
  public var isChangedAccountInfo: Bool {
    return state != originalState
  }
  
  public var nicknameErrorMessage: String? {
    return UserInfoValidator.nicknameErrorMessage(for: state.nickname)
  }
  
  public var heightErrorMessage: String? {
    return UserInfoValidator.heightErrorMessage(for: state.height)
  }
  
  public var weightErrorMessage: String? {
    return UserInfoValidator.weightErrorMessage(for: state.weight)
  }
}
