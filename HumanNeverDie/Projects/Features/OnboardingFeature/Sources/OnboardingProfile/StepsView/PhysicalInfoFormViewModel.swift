//
//  PhysicalInfoFormViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 8/20/25.
//

import Foundation
import UserDomain
import CommonFeature

@Observable
@MainActor
public final class PhysicalInfoFormViewModel: ViewModelable {
  private let validator: UserInfoValidationUseCase
  private weak var parentViewModel: OnboardingProfileViewModel?
  
  public struct State: Equatable {
    var height: Int = 0
    var weight: Int = 0
    var selectedActivity: ActivityLevel = .none
  }
  
  public enum Action {
    case onAppear
    case updateHeight(String)
    case updateWeight(String)
    case updateActivity(ActivityLevel)
    case submitPhysicalInfo
  }
  
  public var state: State = .init()
  
  public init(
    parentViewModel: OnboardingProfileViewModel,
    validator: UserInfoValidationUseCase = DefaultUserInfoValidationUseCase()
  ) {
    self.parentViewModel = parentViewModel
    self.validator = validator
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .updateHeight(let height):
      state.height = Int(height) ?? 0
      updateParentData()
      
    case .updateWeight(let weight):
      state.weight = Int(weight) ?? 0
      updateParentData()
      
    case .updateActivity(let activity):
      state.selectedActivity = activity
      updateParentData()
      
    case .submitPhysicalInfo:
      guard isValidPhysicalInfo else { return }
      updateParentData()
      parentViewModel?.proceedToNextStep()
    }
  }
  
  private func updateParentData() {
    guard let parentViewModel = parentViewModel else { return }
    
    let currentUserInfo = parentViewModel.currentUserInfo
    let userInfo = UserInfo(
      nickname: currentUserInfo.nickname,
      birthDate: currentUserInfo.birthDate,
      selectedGender: currentUserInfo.selectedGender,
      height: state.height,
      weight: state.weight,
      selectedActivity: state.selectedActivity,
      selectedDailySugarGoal: currentUserInfo.selectedDailySugarGoal,
      sugarMaxG: currentUserInfo.sugarMaxG,
      sugarIdealG: currentUserInfo.sugarIdealG
    )
    
    parentViewModel.updatePhysicalInfoData(userInfo)
  }
}

// MARK: - Public Interface
extension PhysicalInfoFormViewModel {
  public func getIntConvertString(_ number: Int) -> String {
    return number == 0 ? "" : String(number)
  }
  
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
