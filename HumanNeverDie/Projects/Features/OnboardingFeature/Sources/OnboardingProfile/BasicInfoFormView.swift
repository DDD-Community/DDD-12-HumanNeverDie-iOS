//
//  BasicInfoFormView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/11/25.
//

import SwiftUI

import DesignSystem

struct BasicInfoFormView: View {
  @State private var nickname: String = ""
  @State private var birthDate: String = ""
  @State private var selectedGender: Gender = .male
  @State private var showAlert = false
  
  enum Gender: String, CaseIterable {
    case male = "남성"
    case female = "여성"
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
    VStack(spacing: 0) {
      HStack {
        Text("기본 정보를 입력해주세요")
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.black)
        
        Spacer()
        
        Text("1/3")
          .font(.system(size: 16))
          .foregroundColor(.gray)
      }
      .padding(.horizontal, 20)
      .padding(.top, 30)
    }
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    VStack(spacing: 30) {
      
      nicknameInputView()
      birthDateInputView()
      genderSelectionView()
    }
    .padding(.horizontal, 20)
    .padding(.top, 48)
  }
  
  // MARK: - Nickname Input
  @ViewBuilder
  private func nicknameInputView() -> some View {
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
  private func birthDateInputView() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      
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
  }
  
  @ViewBuilder
  private func genderSelectionView() -> some View {
  
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
        print("다음 탭됨")
      }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 50)
  }
  
}

struct BasicInfoFormView_Previews: PreviewProvider {
  static var previews: some View {
    BasicInfoFormView()
  }
}
