//
//  OnboardingProfileViewModel.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/12/25.
//

import Foundation

import UserDomain
import CommonFeature
import DesignSystem
import Shared

import Dependencies

@Observable
@MainActor
public final class OnboardingProfileViewModel: ViewModelable {
  private(set) var currentStep: OnboardingStep = .basicInfo
  
  public struct State: Equatable {
    var userID: String = ""
    var isLoading: Bool = false
    
    var userInfo: UserInfo = .defaultUserInfo
    var isPermissionGranted: Bool = false
  }
  
  public enum Action {
    case onAppear
    case moveToNextStep
    case updateBasicInfo(UserInfo)
    case updatePhysicalInfo(UserInfo)
    case updateGoalInfo(UserInfo)
    case completeOnboarding
  }
  
  public var state: State = .init()
  
  @ObservationIgnored
  @Dependency(\.userUseCase) private var userUseCase
  
  @ObservationIgnored
  @Dependency(\.keychainClient) private var keychainClient
  
  @ObservationIgnored
  @Dependency(\.userDefaultClient) private var userDefaultClient
  
  @ObservationIgnored
  @Dependency(\.toastClient) private var toastClient
  
  @ObservationIgnored
  @Dependency(\.alertClient) private var alertClient
  
  public init() {
    if let userID = keychainClient.getValue(forKey: AMDKeychainKey.userID) {
      state.userID = userID
    }
  }
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break

    case .moveToNextStep:
      moveToNextStep()
      
    case .updateBasicInfo(let userInfo):
      updateUserInfo(userInfo)
      
    case .updatePhysicalInfo(let userInfo):
      updateUserInfo(userInfo)
      
    case .updateGoalInfo(let userInfo):
      updateUserInfo(userInfo)
      
    case .completeOnboarding:
      Task {
        await userDefaultClient.setValue(true, forKey: AMDUserDefaultKey.isFirstHome)
        await userDefaultClient.setValue(true, forKey: AMDUserDefaultKey.isFirstBeverageList)
        await completeOnboarding()
      }
    }
  }
  
  // MARK: - UserInfo 업데이트 메서드들
  private func updateUserInfo(_ newUserInfo: UserInfo) {
     state.userInfo = newUserInfo
   }
   
  
  // MARK: - Navigation
  private func moveToNextStep() {
    let allSteps = OnboardingStep.allCases
    guard let currentIndex = allSteps.firstIndex(of: currentStep),
          currentIndex < allSteps.count - 1 else { return }
    
    let nextStep = allSteps[currentIndex + 1]
    
    // goalSetting 완료 시 서버 저장 후 다음 단계로
    if currentStep == .goalSetting {
      Task { await saveUserInfoAndMoveNext() }
    } else {
      moveToStep(nextStep)
    }
  }
  
  private func moveToStep(_ step: OnboardingStep) {
    currentStep = step
  }
  
  private func saveUserInfoAndMoveNext() async {
    await updateUserInfo(state.userInfo)
    
    if !state.isLoading {
      let allSteps = OnboardingStep.allCases
      if let currentIndex = allSteps.firstIndex(of: currentStep),
         currentIndex < allSteps.count - 1 {
        moveToStep(allSteps[currentIndex + 1])
      }
    }
  }
  
  private func completeOnboarding() async {
    // 온보딩 완료 로직
    print("온보딩 완료")
  }
  
  // MARK: - API Calls
  private func updateUserInfo(_ userInfo: UserInfo) async {
    state.isLoading = true
    
    do {
      _ = try await userUseCase.updateUserInfo(userID: state.userID, userInfo: userInfo)
      state.isLoading = false
    } catch {
      showToast(message: "저장에 실패하였습니다", type: .failure)
      state.isLoading = false
    }
  }

  private func showToast(message: String, type: AMDToastType) {
    Task { @MainActor in
      await toastClient.showToast(.init(message: message, type: type))
    }
  }
}

// MARK: - Public Interface for Child ViewModels
extension OnboardingProfileViewModel {
  // 각 단계별 ViewModel에서 호출할 수 있는 메서드들
  public func updateBasicInfoData(_ userInfo: UserInfo) {
    handleAction(.updateBasicInfo(userInfo))
  }
  
  public func updatePhysicalInfoData(_ userInfo: UserInfo) {
    handleAction(.updatePhysicalInfo(userInfo))
  }
  
  public func updateGoalInfoData(_ userInfo: UserInfo) {
    handleAction(.updateGoalInfo(userInfo))
  }
  
  public func proceedToNextStep() {
    handleAction(.moveToNextStep)
  }
  
  // 현재 UserInfo 전체를 각 ViewModel에서 참조할 수 있도록
  public var currentUserInfo: UserInfo {
    state.userInfo
  }
}
