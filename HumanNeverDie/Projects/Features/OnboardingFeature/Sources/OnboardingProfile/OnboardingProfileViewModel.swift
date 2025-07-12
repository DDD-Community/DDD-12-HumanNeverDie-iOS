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
    

    var selectedGoal: SugarGoal = .none
    

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
    }
  }
  
  private func moveToNextStep() {
    let allSteps = OnboardingStep.allCases
    
    if let currentIndex = allSteps.firstIndex(of: currentStep),
       currentIndex < allSteps.count - 1 {
      currentStep = allSteps[currentIndex + 1]
      print("다음 단계로 이동: \(currentStep)")
    } else {
      print("메인 뷰 이동")
    }
  }
}

//BasicInfoFormView
extension OnboardingProfileViewModel {
  
  var isValidBasicInfo: Bool {
    return isValidNickname  && isValidBirthDate && isValidGender
  }
  
  var isValidNickname: Bool {
    let trimmedNickname = state.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
    return !trimmedNickname.isEmpty &&
    trimmedNickname.count <= 10 &&
    trimmedNickname.isValidNicknameFormat
  }
  
  var isValidBirthDate: Bool {
    return true
  }
  
  var isValidGender: Bool {
    return state.selectedGender.isSelected
  }
  
  public var nicknameErrorMessage: String? {
    if state.nickname.isEmpty {
      return "닉네임을 입력해주세요."
    }
    
    if !state.nickname.isValidNicknameFormat {
      return "특수문자 및 공백은 사용할 수 없어요."
    }
    
    return nil
  }
}

//PhysicalInfoFormView
extension OnboardingProfileViewModel {
  
  var isValidPhysicalInfo: Bool {
    return isValidHeight && isValidWeight && isValidActivity
  }
  
  var isValidHeight: Bool {
    guard !state.height.isEmpty else { return false }
    guard let heightValue = Int(state.height) else { return false }
    return heightValue > 0 && heightValue <= 300
  }
  
  var isValidWeight: Bool {
    guard !state.weight.isEmpty else { return false }
    guard let weightValue = Int(state.weight) else { return false }
    return weightValue > 0 && weightValue <= 300
  }
  
  var isValidActivity: Bool {
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

 
extension String {
  var isValidNicknameFormat: Bool {
    let regex = "^[가-힣a-zA-Z0-9]{1,10}$"
    let test = NSPredicate(format: "SELF MATCHES %@", regex)
    return test.evaluate(with: self)
  }
}


