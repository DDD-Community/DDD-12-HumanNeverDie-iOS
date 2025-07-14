//
//  OnboardingProfileViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/12/25.
//

import Foundation
import Observation

import CommonFeature

@Observable
@MainActor
public final class OnboardingProfileViewModel: ViewModelable {
  private(set) var currentStep: OnboardingStep = .basicInfo
  
  public struct State: Equatable {
    //BasicInfoFormView
    var nickname: String = ""
    var birthDate: String = ""
    var selectedGender: Gender = .none
    
    // PhysicalInfo Actions
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
    case moveToNextStep
    
    // BasicInfo Actions
    case updateNickname(String)
    case updateBirthDate(String)
    case updateGender(Gender)
    
    // PhysicalInfo Actions
    case updateHeight(String)
    case updateWeight(String)
    case updateActivity(ActivityLevel)
    
    case updateDailySugarGoal(SugarGoal)
  }
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .moveToNextStep:
      moveToNextStep()
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
      
    case .updateDailySugarGoal(let activity):
      state.selectedDailySugarGoal = activity
    }
  }
  
  private func moveToNextStep() {
    let allSteps = OnboardingStep.allCases
    
    if let currentIndex = allSteps.firstIndex(of: currentStep),
       currentIndex < allSteps.count - 1 {
      currentStep = allSteps[currentIndex + 1]
    }
  }
}

//BasicInfoFormView
extension OnboardingProfileViewModel {
  
  public var isValidBasicInfo: Bool {
    return isValidNickname  && isValidBirthDate && isValidGender
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
}

//PhysicalInfoFormView
extension OnboardingProfileViewModel {
  
  public var isValidPhysicalInfo: Bool {
    return isValidHeight && isValidWeight && isValidActivity
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
extension OnboardingProfileViewModel {
  
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


