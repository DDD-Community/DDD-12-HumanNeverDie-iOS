//
//  DailySugarGoalViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 8/20/25.
//

import Foundation
import UserDomain
import CommonFeature
import Dependencies
import Shared

@Observable
@MainActor
public final class DailySugarGoalViewModel: ViewModelable {
  private weak var parentViewModel: OnboardingProfileViewModel?
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  @ObservationIgnored
  @Dependency(\.keychainClient) private var keychainClient
  
  public struct State: Equatable {
    var selectedDailySugarGoal: SugarGoal = .none
    
    var showAlert: Bool = false
    var isShowingSugarCalculationInfo: Bool = false
    var userSugarLevel: UserSugarLevel?
  }
  
  public enum Action {
    case onAppear
    case updateDailySugarGoal(SugarGoal)
    case submitGoalInfo
    case showCalculationModal(Bool)
    
    case showSugarCalculationInfo
    case hideSugarCalculationInfo
  }
  
  public var state: State = .init()
  
  public init(parentViewModel: OnboardingProfileViewModel) {
    self.parentViewModel = parentViewModel
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        await loadUserSugarLevel()
      }
      
    case .updateDailySugarGoal(let goal):
      state.selectedDailySugarGoal = goal
      updateParentData()
      
    case .submitGoalInfo:
      guard isValidDailySugarGoal else { return }
      updateParentData()
      parentViewModel?.proceedToNextStep()
    case .showCalculationModal(let isShow):
      state.showAlert = isShow
    case .showSugarCalculationInfo:
      state.isShowingSugarCalculationInfo = true
      
    case .hideSugarCalculationInfo:
      state.isShowingSugarCalculationInfo = false
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
  private func loadUserSugarLevel() async {
    guard let userID = keychainClient.getValue(forKey: AMDKeychainKey.userID) else { return }
    let userSugarLevel = await userUseCase.getUserSugarLavel(userID: userID)
    await MainActor.run {
      state.userSugarLevel = userSugarLevel
    }
  }

  public func getSugarGoalAmount(for goal: SugarGoal) -> Int {
    guard let userSugarLevel = state.userSugarLevel else { return 0 }
    
    switch goal {
    case .easy:
      return userSugarLevel.data.easy.sugarMaxG
    case .normal:
      return userSugarLevel.data.normal.sugarMaxG
    case .hard:
      return userSugarLevel.data.hard.sugarMaxG
    case .none:
      return 0
    }
  }
  
  public var isValidDailySugarGoal: Bool {
    return state.selectedDailySugarGoal != .none
  }
  
  public var nickname: String {
    return parentViewModel?.currentUserInfo.nickname ?? ""
  }
}
