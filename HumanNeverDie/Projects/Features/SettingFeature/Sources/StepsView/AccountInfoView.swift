//
//  AccountInfoView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/16/25.
//

import SwiftUI

import UserDomain
import DesignSystem
import CommonFeature

public struct AccountInfoView: View {
  @State public var viewModel: AccountInfoViewModel
  @Environment(Router.self) private var router
  @FocusState private var isNicknameFocused: Bool
  @FocusState private var isHeightFocused: Bool
  @FocusState private var isWeightFocused: Bool
  
  public init(viewModel: AccountInfoViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ScrollView {
      contentBasicInfoFormView()
        .padding(.bottom, 30)
      
      sectionDivider()
      contentPhysicalInfoView()
      Spacer()
      bottomButtonView()
        .padding(.top, 30)
      
    }.settingToolbar(item: .accountInfo) {
      self.router.pop()
    }
  }
}

extension AccountInfoView {
  @ViewBuilder
  private func contentBasicInfoFormView() -> some View {
    VStack(spacing: 30) {
      AMDTextField.titleLabel("기본정보")
      
      AMDTextField(
        text: Binding(
          get: { viewModel.state.nickname },
          set: { viewModel.handleAction(.updateNickname($0)) }
        ),
        isFocused: $isNicknameFocused,
        title: "닉네임",
        placeholder: "닉네임을 입력해주세요",
        rightButtonType: .edit,
        rightButtonAction: {
          isNicknameFocused = true
        },
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
    .amdBottomSheet(isPresented: $viewModel.state.showAlert, detents: [.height(310)]) {
      AMDDatePickerView(
        title: "생년월일",
        isResetButtonHidden: true,
        type: .yearMonthDay,
        initialDate: viewModel.birthDate
      ) {
        viewModel.handleAction(.updateBirthDate($0))
      }
    }
    .padding(.horizontal, 20)
    .onAppear {
        viewModel.setRouter(router)
    }
  }
  
  @ViewBuilder
  private func contentGenderSection() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      AMDTextField.titleLabel("성별")
      
      HStack(spacing: 12) {
        ForEach([Gender.MALE, Gender.FEMALE], id: \.self) { gender in
          AMDChipButton(
            title: gender.description,
            isSelected: viewModel.state.selectedGender  == gender
          ) {
            viewModel.state.selectedGender  = gender
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func contentPhysicalInfoView() -> some View {
    VStack(spacing: 30) {
      AMDTextField.titleLabel("신체 정보")
      
      AMDTextField(
        text: Binding(
          get: { "\(viewModel.state.height)"},
          set: { viewModel.handleAction(.updateHeight($0)) }
        ),
        isFocused: $isHeightFocused,
        title: "키",
        titleSuffix: "cm",
        placeholder: "키를 입력해주세요",
        rightButtonType: .edit,
        rightButtonAction: {
          isHeightFocused = true
        },
        errorMessage: viewModel.heightErrorMessage
      )
      
      AMDTextField(
        text: Binding(
          get: { "\(viewModel.state.weight)" },
          set: { viewModel.handleAction(.updateWeight($0)) }
        ),
        isFocused: $isWeightFocused,
        title: "몸무게",
        titleSuffix: "kg",
        placeholder: "몸무게를 입력해주세요",
        rightButtonType: .edit,
        rightButtonAction: {
          isWeightFocused = true
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
        ForEach([ActivityLevel.tight, ActivityLevel.normal, ActivityLevel.loose], id: \.self) { activity in
          AMDOptionButton(
            title: activity.description,
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
    SettingBottomButton(
      type: viewModel.isChangedAccountInfo ? .default : .secondary
    ) {
      guard viewModel.isChangedAccountInfo else {
        self.router.pop()
        return
      }
      
      withAnimation(.easeInOut) {
        viewModel.handleAction(.updateAccountInfoUserInfo)
      }
    }
  }
  
  private func sectionDivider() -> some View {
    Divider()
      .background(.gray25)
  }
}
