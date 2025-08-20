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
      BasicInfoFormView(
        viewModel: BasicInfoFormViewModel(parentViewModel: viewModel)
      )
    case .physicalInfo:
      PhysicalInfoFormView(
        viewModel: PhysicalInfoFormViewModel(parentViewModel: viewModel)
      )
    case .goalSetting:
      DailySugarGoalView(
        viewModel: DailySugarGoalViewModel(parentViewModel: viewModel)
      )
    case .permission:
      PermissionView(
        viewModel: PermissionViewModel(parentViewModel: viewModel)
      )
    }
    
  }
}
