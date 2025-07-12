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
  var currentStep: OnboardingStep = .basicInfo
  
  public struct State: Equatable {
    // 기본 정보
    var nickname: String = ""
    var birthDate: String = ""
    var selectedGender: Gender = .none
    
    // 신체 정보
    var height: String = ""
    var weight: String = ""
    var selectedActivity: ActivityLevel = .none
    
    // 목표 설정
    var selectedGoal: SugarGoal = .none
    
    // 권한
    var isPermissionGranted: Bool = false
  }
  
  public enum Action {
    case onAppear
    case moveToNextStep
  }
  
  public var state: State = .init()
  public init() {}
  
  public func handleAction(_ action: Action) {
    switch action {
    case .onAppear:
      break
      
    case .moveToNextStep:
      moveToNextStep()
      break
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

