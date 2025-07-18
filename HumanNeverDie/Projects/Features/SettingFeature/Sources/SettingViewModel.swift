//
// SettingViewModel.swift
// Setting
//
// Created by Seulki Lee on 2025.
//
import Foundation
import Observation

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
  
  private var isValidNickname: Bool {
    let trimmedNickname = state.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
    return !trimmedNickname.isEmpty &&
    trimmedNickname.count <= 10 &&
    trimmedNickname.isValidNicknameFormat
  }
  
  private var isValidBirthDate: Bool {
    return true
  }
  
  private var isValidGender: Bool {
    return state.selectedGender.isSelected
  }
  
  public var nicknameErrorMessage: String? {
    if state.nickname.isEmpty {
      return nil
    }
    
    if state.nickname.count < 2 {
      return "닉네임은 2자 이상 입력해주세요."
    }
    
    if state.nickname.count > 10 {
      return "닉네임은 10자 이하로 입력해주세요."
    }
    
    if !state.nickname.isValidNicknameFormat {
      return "닉네임은 띄어쓰기 없이 한글, 영문, 숫자로 입력해주세요."
    }
    
    return nil
  }
  
  private var isValidHeight: Bool {
    guard !state.height.isEmpty else { return false }
    guard let heightValue = Int(state.height) else { return false }
    return heightValue > 0 && heightValue <= 300
  }
  
  private var isValidWeight: Bool {
    guard !state.weight.isEmpty else { return false }
    guard let weightValue = Int(state.weight) else { return false }
    return weightValue > 0 && weightValue <= 300
  }
  
  private var isValidActivity: Bool {
    return state.selectedActivity.isSelected
  }
  
  public var heightErrorMessage: String? {
    if state.height.isEmpty {
      return nil
    }
    
    guard let heightValue = Int(state.height) else {
      return "키는 0-300 사이의 숫자를 입력해주세요"
    }
    
    if heightValue <= 0 || heightValue > 300 {
      return "키는 0-300 사이의 숫자를 입력해주세요"
    }
    
    return nil
  }
  
  public var weightErrorMessage: String? {
    if state.weight.isEmpty {
      return nil
    }
    
    guard let weightValue = Int(state.weight) else {
      return "몸무게는 0-300 사이의 숫자를 입력해주세요"
    }
    
    if weightValue <= 0 || weightValue > 300 {
      return "몸무게는 0-300 사이의 숫자를 입력해주세요"
    }
    
    return nil
  }
}

//DailySugarGoalView
extension SettingViewModel {
  
  public var isValidDailySugarGoal: Bool {
    return state.selectedDailySugarGoal.isSelected
  }
}


extension String {
  public var isValidNicknameFormat: Bool {
    let regex = "^[가-힣a-zA-Z0-9]{1,10}$"
    let test = NSPredicate(format: "SELF MATCHES %@", regex)
    return test.evaluate(with: self)
  }
}



