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
  
  public struct State: Equatable {
    //AccountInfoView
    var nickname: String = ""
    var birthDate: String = ""
    var selectedGender: Gender = .none
    var height: String = ""
    var weight: String = ""
    var selectedActivity: ActivityLevel = .none
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

  public init(userInfo: UserInfo) {
      let initialState = State(
          nickname: userInfo.nickname,
          birthDate: userInfo.birthDate,
          selectedGender: userInfo.selectedGender,
          height: userInfo.height,
          weight: userInfo.weight,
          selectedActivity: userInfo.selectedActivity
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
      
    }
  }
}

//AccountInfoView
extension AccountInfoViewModel {
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

