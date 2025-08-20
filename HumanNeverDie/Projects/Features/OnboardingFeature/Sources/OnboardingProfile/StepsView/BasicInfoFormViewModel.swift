//
//  BasicInfoFormViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 8/20/25.
//

import Foundation
import UserDomain
import CommonFeature

@Observable
@MainActor
public final class BasicInfoFormViewModel: ViewModelable {
  private let validator: UserInfoValidationUseCase
  private weak var parentViewModel: OnboardingProfileViewModel?
  
  public struct State: Equatable {
    var nickname: String = ""
    var birthDate: Date? = nil
    var showAlert = false
    var selectedGender: Gender = .none
  }
  
  public enum Action {
    case onAppear
    case updateNickname(String)
    case updateBirthDate(Date)
    case updateGender(Gender)
    case submitBasicInfo
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
      
    case .updateNickname(let nickname):
      state.nickname = nickname
      updateParentData()
      
    case .updateBirthDate(let birthDate):
      state.birthDate = birthDate
      state.showAlert = false
      updateParentData()
      
    case .updateGender(let gender):
      state.selectedGender = gender
      updateParentData()
      
    case .submitBasicInfo:
      guard isValidBasicInfo else { return }
      updateParentData()
      parentViewModel?.proceedToNextStep()
    }
  }
  
  private func updateParentData() {
    guard let parentViewModel = parentViewModel else { return }
  
    let currentUserInfo = parentViewModel.currentUserInfo
    let userInfo = UserInfo(
      nickname: state.nickname,
      birthDate: state.birthDate != nil ? Date.toDateKeyString(from: state.birthDate!) : "",
      selectedGender: state.selectedGender,
      height: currentUserInfo.height,
      weight: currentUserInfo.weight,
      selectedActivity: currentUserInfo.selectedActivity,
      selectedDailySugarGoal: currentUserInfo.selectedDailySugarGoal,
      sugarMaxG: currentUserInfo.sugarMaxG,
      sugarIdealG: currentUserInfo.sugarIdealG
    )
    
    parentViewModel.updateBasicInfoData(userInfo)
  }
}

// MARK: - Public Interface
extension BasicInfoFormViewModel {
  public var getBirthDateConvertString: String {
    guard let birthDate = state.birthDate else { return "" }
    return Date.toDateTitleString(from: birthDate)
  }
  
  public var isValidBasicInfo: Bool {
    return validator.isValidNickname(state.nickname) &&
           state.birthDate != nil &&
           state.selectedGender != .none
  }
  
  public var nicknameErrorMessage: String? {
    return validator.nicknameErrorMessage(for: state.nickname)
  }
}
