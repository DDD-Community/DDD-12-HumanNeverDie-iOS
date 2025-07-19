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
    return UserInfoValidator.isValidNickname(state.nickname) &&
           UserInfoValidator.isValidBirthDate(state.birthDate) &&
           UserInfoValidator.isValidGender(state.selectedGender)
  }
  
  public var nicknameErrorMessage: String? {
    return UserInfoValidator.nicknameErrorMessage(for: state.nickname)
  }
}

//PhysicalInfoFormView
extension OnboardingProfileViewModel {
  
  public var isValidPhysicalInfo: Bool {
    return UserInfoValidator.isValidHeight(state.height) &&
           UserInfoValidator.isValidWeight(state.weight) &&
           UserInfoValidator.isValidActivity(state.selectedActivity)
  }
  
  public var heightErrorMessage: String? {
    return UserInfoValidator.heightErrorMessage(for: state.height)
  }
  
  public var weightErrorMessage: String? {
    return UserInfoValidator.weightErrorMessage(for: state.weight)
  }
}

//DailySugarGoalView
extension OnboardingProfileViewModel {
  
  public var isValidDailySugarGoal: Bool {
    return UserInfoValidator.isValidDailySugarGoal(state.selectedDailySugarGoal)
  }
}
