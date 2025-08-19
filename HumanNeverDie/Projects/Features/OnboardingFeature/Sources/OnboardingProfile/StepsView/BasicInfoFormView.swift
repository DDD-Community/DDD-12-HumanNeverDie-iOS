//
//  BasicInfoFormView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/11/25.
//

import SwiftUI
import UserDomain
import DesignSystem
import CommonFeature

struct BasicInfoFormView: View {
  @State private var viewModel: BasicInfoFormViewModel
  
  public init(viewModel: BasicInfoFormViewModel) {
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
    .amdBottomSheet(isPresented: $viewModel.state.showAlert, detents: [.height(310)]) {
      AMDDatePickerView(
        title: "생년월일",
        isResetButtonHidden: true,
        type: .yearMonthDay,
        initialDate: viewModel.state.birthDate ?? Date()
      ) {
        viewModel.handleAction(.updateBirthDate($0))
      }
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
  }
}

extension BasicInfoFormView {
  @ViewBuilder
  private func topHeaderView() -> some View {
    OnboardingTopHeaderView(
      title: "기본 정보를 입력해주세요",
      stepText: "1/3"
    )
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    VStack(spacing: 30) {
      AMDTextField(
        text: Binding(
          get: { viewModel.state.nickname },
          set: { viewModel.handleAction(.updateNickname($0)) }
        ),
        title: "닉네임",
        placeholder: "닉네임을 입력해주세요",
        errorMessage: viewModel.nicknameErrorMessage
      )
      
      AMDTextField(
        text: Binding(
          get: { viewModel.getBirthDateConvertString },
          set: { _ in }
        ),
        title: "생년월일",
        placeholder: "생년월일을 입력해 주세요",
        rightButtonType: .date,
        rightButtonAction: {
          viewModel.state.showAlert = true
        }
      )
      
      contentGenderSection()
    }
    .padding(.horizontal, 20)
    .padding(.top, 48)
  }
  
  @ViewBuilder
  private func contentGenderSection() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      AMDTextField.titleLabel("성별")
      
      HStack(spacing: 12) {
        ForEach([Gender.MALE, Gender.FEMALE], id: \.self) { gender in
          AMDChipButton(
            title: gender.description,
            isSelected: viewModel.state.selectedGender == gender
          ) {
            viewModel.handleAction(.updateGender(gender))
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func bottomButtonView() -> some View {
    OnboardingBottomButton(
      type: viewModel.isValidBasicInfo ? .default : .secondary
    ) {
      viewModel.handleAction(.submitBasicInfo)
    }
  }
}
