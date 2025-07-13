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
}
