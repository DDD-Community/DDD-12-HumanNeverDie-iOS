//
//  BasicInfoFormView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/11/25.
//

import SwiftUI

import DesignSystem

struct BasicInfoFormView: View {
  @State private var viewModel: OnboardingProfileViewModel
  @State private var nickname: String = ""
  @State private var birthDate: String = ""
  @State private var showAlert = false
  @State private var selectedGender: Gender = .none
  
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
      
      nicknameSection()
      birthDateSection()
      genderSection()
    }
    .padding(.horizontal, 20)
    .padding(.top, 48)
  }
  
  @ViewBuilder
  private func nicknameSection() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      AMDTextField(
        text: $nickname,
        title: "닉네임",
        placeholder: "닉네임을 입력해주세요",
        errorMessage: "특수문자 및 공백은 사용할 수 없어요."
      )
    }
  }
  
  @ViewBuilder
  private func birthDateSection() -> some View {
    AMDTextField(
      text: $birthDate,
      title: "생년월일",
      placeholder: "생년월일을 입력해 주세요",
      rightButtonType: .date,
      rightButtonAction: {
        showAlert = true
      }
    )
  }
  
  @ViewBuilder
  private func genderSection() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      AMDTextField.titleLabel("성별")
      
      HStack(spacing: 12) {
        ForEach([Gender.male, Gender.female], id: \.self) { gender in
          AMDChipButton(
            title: gender.rawValue,
            isSelected: selectedGender == gender
          ) {
            selectedGender = gender
          }
        }
        
        Spacer()
      }
    }
  }
  
  @ViewBuilder
  private func bottomButtonView() -> some View {
    OnboardingBottomButton(
      type: .default
    ) {
      viewModel.handleAction(.moveToNextStep)
    }
  }
}
