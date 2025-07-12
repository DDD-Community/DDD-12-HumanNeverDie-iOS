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
  @State private var userHeight: String = ""
  @State private var userWeight: String = ""
  @State private var selectedActivity: ActivityLevel = .none
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
    HStack {
      Text("신체 정보를 입력해주세요")
        .amdFont(.xxlargeBold)
        .foregroundColor(.gray80)
      
      Spacer()
      
      Text("2/3")
        .amdFont(.smallRegular)
        .foregroundColor(.gray50)
    }
    .padding(.horizontal, 20)
    .padding(.top, 30)
  }
}

extension PhysicalInfoFormView {
  @ViewBuilder
  private func contentView() -> some View {
    VStack(spacing: 30) {
      heightSection()
      weightSection()
      activitySection()
    }
    .padding(.horizontal, 20)
    .padding(.top, 48)
  }
  
  @ViewBuilder
  private func heightSection() -> some View {
    AMDTextField(
      text: $userHeight,
      title: "키",
      placeholder: "키를 입력해주세요",
      rightButtonType: .none,
      rightButtonAction: {
        showAlert = true
      }
    )
  }
  
  @ViewBuilder
  private func weightSection() -> some View {
    AMDTextField(
      text: $userWeight,
      title: "몸무게",
      placeholder: "몸무게를 입력해주세요",
      rightButtonType: .none,
      rightButtonAction: {
        showAlert = true
      }
    )
  }
  
  @ViewBuilder
  private func activitySection() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      AMDTextField.titleLabel("활동량")
      
      VStack(spacing: 12) {
        ForEach([ActivityLevel.high, ActivityLevel.medium, ActivityLevel.low], id: \.self) { activity in
          ActivityOptionView(
            title: activity.rawValue,
            isSelected: selectedActivity == activity
          ) {
            selectedActivity = activity
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func bottomButtonView() -> some View {
    Button(action: {
      // 다음 단계로 이동
    }) {
      AMDButton(
        type: .default,
        title: "다음"
      ) {
        viewModel.handleAction(.moveToNextStep)
      }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 50)
  }
}

struct ActivityOptionView: View {
  let title: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack {
        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
          .foregroundColor(isSelected ? .amdPrimary : .gray25)
          .font(.system(size: 24))
        
        Text(title)
          .amdFont(.mediumBold)
          .foregroundColor(.gray85)
        
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(isSelected ? .amdPrimary.opacity(0.1) : .gray0)
          .stroke(isSelected ? .amdPrimary : .gray25, lineWidth: 1)
      )
    }
  }
}
