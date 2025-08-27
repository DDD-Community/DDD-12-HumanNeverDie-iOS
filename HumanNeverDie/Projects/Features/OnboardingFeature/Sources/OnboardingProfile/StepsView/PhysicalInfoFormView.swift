//
//  PhysicalInfoFormView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/11/25.
//

import SwiftUI
import UserDomain
import CommonFeature
import DesignSystem

struct PhysicalInfoFormView: View {
  @State private var viewModel: PhysicalInfoFormViewModel
  @State private var showAlert = false
  
  @FocusState private var heightFieldFocused: Bool
  @FocusState private var weightFieldFocused: Bool
  
  public init(viewModel: PhysicalInfoFormViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.clear
          .contentShape(Rectangle())
          .onTapGesture {
            hideKeyboard()
          }
        
        VStack(spacing: 0) {
          ScrollView {
            VStack(spacing: 0) {
              topHeaderView()
              contentView()
            }
            .background(Color.white)
          }
          .scrollIndicators(.hidden)
          .scrollBounceBehavior(.basedOnSize)
          
          bottomButtonView()
            .background(Color.white)
        }
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      viewModel.handleAction(.onAppear)
      UIScrollView.appearance().bounces = false
    }
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
          get: { viewModel.getIntConvertString(viewModel.state.height) },
          set: { viewModel.handleAction(.updateHeight($0)) }
        ),
        isFocused:$heightFieldFocused,
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
          get: { viewModel.getIntConvertString(viewModel.state.weight) },
          set: { viewModel.handleAction(.updateWeight($0)) }
        ),
        isFocused:$weightFieldFocused,
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
    .padding(.top, 28)
  }
  
  @ViewBuilder
  private func contentActivitySection() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      AMDTextField.titleLabel("활동량")
      
      VStack(spacing: 12) {
        ForEach([ActivityLevel.tight, ActivityLevel.normal, ActivityLevel.loose], id: \.self) { activity in
          AMDOptionButton(
            title: activity.description,
            subtitle: activity.subDescription,
            isSelected: viewModel.state.selectedActivity == activity
          ) {
            hideKeyboard()
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
      viewModel.handleAction(.submitPhysicalInfo)
    }
  }
}
