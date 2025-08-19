//
//  OnboardingProfileViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/12/25.
//

import Foundation
import UserDomain
import CommonFeature

@Observable
@MainActor
public final class OnboardingProfileViewModel: ViewModelable {
  private(set) var currentStep: OnboardingStep = .basicInfo
  private let validator: UserInfoValidationUseCase
  
  public struct State: Equatable {
    //BasicInfoFormView
    var nickname: String = ""
    var birthDate: Date? = nil
    var showAlert = false
    var selectedGender: Gender = .none
    
    // PhysicalInfo Actions
    var height: Int = 0
    var weight: Int = 0
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
    case updateBirthDate(Date)
    case updateGender(Gender)
    
    // PhysicalInfo Actions
    case updateHeight(String)
    case updateWeight(String)
    case updateActivity(ActivityLevel)
    
    case updateDailySugarGoal(SugarGoal)
  }
  
  public var state: State = .init()
  public init(validator: UserInfoValidationUseCase = DefaultUserInfoValidationUseCase()) {
      self.validator = validator
  }
  
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
      state.showAlert = false
      
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
  
  public var getBirthDateConvertString: String {
   guard let birthDate = state.birthDate else {
     return ""
   }
   
   return Date.toDateTitleString(from: birthDate)
  }
}

//BasicInfoFormView
extension OnboardingProfileViewModel {
  
  public var isValidBasicInfo: Bool {
    return validator.isValidNickname(state.nickname) &&
           state.birthDate != nil &&
    state.selectedGender != .none
  }
  
  public var nicknameErrorMessage: String? {
    return validator.nicknameErrorMessage(for: state.nickname)
  }
}

//PhysicalInfoFormView
extension OnboardingProfileViewModel {
  
  public var isValidPhysicalInfo: Bool {
    return validator.isValidHeight(state.height) &&
    validator.isValidWeight(state.weight) &&
    state.selectedActivity != .none
  }
  
  public var heightErrorMessage: String? {
    return validator.heightErrorMessage(for: state.height)
  }
  
  public var weightErrorMessage: String? {
    return validator.weightErrorMessage(for: state.weight)
  }
}

//DailySugarGoalView
extension OnboardingProfileViewModel {
  
  public var isValidDailySugarGoal: Bool {
    return state.selectedDailySugarGoal != .none
  }
}
