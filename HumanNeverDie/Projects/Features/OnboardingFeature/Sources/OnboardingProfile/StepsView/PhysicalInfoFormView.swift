//
//  PhysicalInfoFormView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/11/25.
//

import SwiftUI
import DesignSystem

struct PhysicalInfoFormView: View {
  @State private var viewModel: OnboardingProfileViewModel
  @State private var showAlert = false
  
  public init(viewModel: OnboardingProfileViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      topHeaderView()
      contentView()
      Spacer()
      bottomButtonView()
    }
    .background(Color.white)
    .ignoresSafeArea(edges: .bottom)
  }
}

extension PhysicalInfoFormView {
  @ViewBuilder
  private func topHeaderView() -> some View {
    OnboardingTopHeaderView(
      title: "신체 정보를 입력해주세요",
      stepText: "2/3"
    )
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    VStack(spacing: 30) {
      AMDTextField(
        text: Binding(
          get: { viewModel.state.height },
          set: { viewModel.handleAction(.updateHeight($0)) }
        ),
        title: "키",
        titleSuffix: "cm",
        placeholder: "키를 입력해주세요",
        rightButtonType: .none,
        rightButtonAction: {
          showAlert = true
        },
        errorMessage: viewModel.heightErrorMessage
      )
      
      AMDTextField(
        text: Binding(
          get: { viewModel.state.weight },
          set: { viewModel.handleAction(.updateWeight($0)) }
        ),
        title: "몸무게",
        titleSuffix: "kg",
        placeholder: "몸무게를 입력해주세요",
        rightButtonType: .none,
        rightButtonAction: {
          showAlert = true
        },
        errorMessage: viewModel.weightErrorMessage
      )
      
      contentActivitySection()
    }
    .padding(.horizontal, 20)
    .padding(.top, 48)
  }
  
  @ViewBuilder
  private func contentActivitySection() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      AMDTextField.titleLabel("활동량")
      
      VStack(spacing: 12) {
        ForEach([ActivityLevel.high, ActivityLevel.medium, ActivityLevel.low], id: \.self) { activity in
          AMDOptionButton(
            title: activity.rawValue,
            isSelected: viewModel.state.selectedActivity == activity
          ) {
            viewModel.handleAction(.updateActivity(activity))
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func bottomButtonView() -> some View {
    OnboardingBottomButton(
      type: viewModel.isValidPhysicalInfo ? .default : .secondary
    ) {
      guard viewModel.isValidPhysicalInfo else { return }
      withAnimation(.easeInOut) {
        viewModel.handleAction(.moveToNextStep)
      }
    }
  }
}
