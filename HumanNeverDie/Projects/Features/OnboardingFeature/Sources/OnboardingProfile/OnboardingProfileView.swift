//
//  OnboardingProfileView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/13/25.
//

import SwiftUI
import CommonFeature

struct OnboardingProfileView: View {
  @State private var viewModel: OnboardingProfileViewModel
  @Environment(Router.self) private var router
  
  init(viewModel: OnboardingProfileViewModel) {
    self._viewModel = State(initialValue: viewModel)
  }
  
  var body: some View {
    switch viewModel.currentStep {
    case .basicInfo:
      BasicInfoFormView(viewModel: viewModel)
    case .physicalInfo:
      PhysicalInfoFormView(viewModel: viewModel)
    case .goalSetting:
      DailySugarGoalView(viewModel: viewModel)
    case .permission:
      PermissionView(viewModel: viewModel)
    }
  }
  
  private func moveToNext() {
    viewModel.handleAction(.moveToNextStep)
  }
  
  private func completeOnboarding() {
    // 온보딩 완료 후 메인으로 이동
    router.setRoute(.main)
  }
}
