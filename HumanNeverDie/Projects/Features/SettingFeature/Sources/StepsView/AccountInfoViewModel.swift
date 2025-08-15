//
//  AccountInfoViewModel.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation

import UserDomain
import CommonFeature

@Observable
@MainActor
public final class AccountInfoViewModel: ViewModelable {
  private let validator: UserInfoValidationUseCase
  
  public struct State: Equatable {
    //AccountInfoView
    var nickname: String = ""
    var birthDate: String = ""
    var selectedGender: Gender = .none
    var height: Int = 0
    var weight: Int = 0
    var selectedActivity: ActivityLevel = .none
    var selectedDailySugarGoal: SugarGoal = .none
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
  }
  
  public var state: State = .init()
  private var originalState: State

  public init(
    userInfo: UserInfo,
    validator: UserInfoValidationUseCase = DefaultUserInfoValidationUseCase()
  ) {
      self.validator = validator

      let initialState = State(
          nickname: userInfo.nickname,
          birthDate: userInfo.birthDate,
          selectedGender: userInfo.selectedGender,
          height: userInfo.height,
          weight: userInfo.weight,
          selectedActivity: userInfo.selectedActivity
      )

    print("🔍 AccountInfoViewModel Init")
    print("📝 selectedGender: \(userInfo.selectedGender)")
    print("📝 selectedActivity: \(userInfo.selectedActivity)")
    print("📝 nickname: \(userInfo.nickname)")
    print("📝 전체 userInfo: \(userInfo)")
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
      
      guard let intValue = Int(height) else { state.height = 0
        return
      }
      state.height = intValue
      
    case .updateWeight(let weight):
      
      guard let intValue = Int(weight) else { state.weight = 0
        return
      }
      state.weight = intValue
      
    case .updateActivity(let activity):
      state.selectedActivity = activity
      
    case .updateAccountInfoUserInfo:
      break
      
    }
  }
}

//AccountInfoView
extension AccountInfoViewModel {
  public var isChangedAccountInfo: Bool {
    return state != originalState
  }
  
  public var nicknameErrorMessage: String? {
    return validator.nicknameErrorMessage(for: state.nickname)
  }
  
  public var heightErrorMessage: String? {
    return validator.heightErrorMessage(for: state.height)
  }
  
  public var weightErrorMessage: String? {
    return validator.weightErrorMessage(for: state.weight)
  }
  
  // 현재 상태를 UserInfo로 변환하는 메서드 추가
  public func getCurrentUserInfo() -> UserInfo {
    return UserInfo(
      nickname: state.nickname,
      birthDate: state.birthDate,
      selectedGender: state.selectedGender,
      height: state.height,
      weight: state.weight,
      selectedActivity: state.selectedActivity,
      selectedDailySugarGoal: state.selectedDailySugarGoal,
    )
  }
}
