//
//  DailySugarGoalViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 8/20/25.
//

import Foundation
import UserDomain
import CommonFeature

@Observable
@MainActor
public final class DailySugarGoalViewModel: ViewModelable {
  private weak var parentViewModel: OnboardingProfileViewModel?
  
  public struct State: Equatable {
    var selectedDailySugarGoal: SugarGoal = .none
    
    var showAlert: Bool = false
  }
  
  public enum Action {
    case onAppear
    case updateDailySugarGoal(SugarGoal)
    case submitGoalInfo
    case showCalculationModal(Bool)
  }
  
  public var state: State = .init()
  
  public init(parentViewModel: OnboardingProfileViewModel) {
    self.parentViewModel = parentViewModel
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .updateDailySugarGoal(let goal):
      state.selectedDailySugarGoal = goal
      updateParentData()
      
    case .submitGoalInfo:
      guard isValidDailySugarGoal else { return }
      updateParentData()
      parentViewModel?.proceedToNextStep()
    case .showCalculationModal(let isShow):
      state.showAlert = isShow
    }
  }
  
  private func updateParentData() {
    guard let parentViewModel = parentViewModel else { return }
    
    let currentUserInfo = parentViewModel.currentUserInfo
    let userInfo = UserInfo(
      nickname: currentUserInfo.nickname,
      birthDate: currentUserInfo.birthDate,
      selectedGender: currentUserInfo.selectedGender,
      height: currentUserInfo.height,
      weight: currentUserInfo.weight,
      selectedActivity: currentUserInfo.selectedActivity,
      selectedDailySugarGoal: state.selectedDailySugarGoal,
      sugarMaxG: currentUserInfo.sugarMaxG,
      sugarIdealG: currentUserInfo.sugarIdealG
    )
    
    parentViewModel.updateGoalInfoData(userInfo)
  }
}

// MARK: - Public Interface
extension DailySugarGoalViewModel {
  public func getSugarGoalAmount(for goal: SugarGoal) -> Int {
    guard let parentViewModel = parentViewModel else { return 0 }
  
    let currentUserInfo = parentViewModel.currentUserInfo
    
    let tempUserInfo = UserInfo(
      nickname: currentUserInfo.nickname,
      birthDate: currentUserInfo.birthDate,
      selectedGender: currentUserInfo.selectedGender,
      height: currentUserInfo.height,
      weight: currentUserInfo.weight,
      selectedActivity: currentUserInfo.selectedActivity,
      selectedDailySugarGoal: goal,
      sugarMaxG: currentUserInfo.sugarMaxG,
      sugarIdealG: currentUserInfo.sugarIdealG
    )
    
    return sugarGoalCalculator(userInfo: tempUserInfo)
  }
  
  public var isValidDailySugarGoal: Bool {
    return state.selectedDailySugarGoal != .none
  }
  
  public var nickname: String {
    return parentViewModel?.currentUserInfo.nickname ?? ""
  }
}
