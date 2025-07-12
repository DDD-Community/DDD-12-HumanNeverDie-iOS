//
//  DailySugarGoalView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/11/25.
//

import SwiftUI
import DesignSystem

struct DailySugarGoalView: View {
  @State private var viewModel: OnboardingProfileViewModel
  @State private var selectedGoal: SugarGoal = .none
  
  public init(viewModel: OnboardingProfileViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      topHeaderView()
      contentView()
      bottomInfoView()
      Spacer()
      bottomButtonView()
    }
    .background(Color.white)
    .ignoresSafeArea(edges: .bottom)
  }
}

extension DailySugarGoalView {
  @ViewBuilder
  private func topHeaderView() -> some View {
    HStack(alignment: .lastTextBaseline) {
      Text("일일 당 섭취량 목표를\n정해주세요")
        .amdFont(.xxlargeBold)
        .foregroundColor(.gray80)
        .multilineTextAlignment(.leading)
      
      Spacer()
      
      Text("3/3")
        .amdFont(.smallRegular)
        .foregroundColor(.gray50)
        .multilineTextAlignment(.trailing)
    }
    .padding(.horizontal, 20)
    .padding(.top, 30)
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    VStack(spacing: 32) {
      VStack(spacing: 0) {
        characterImageView()
        recommendationTextView()
      }
      goalSelectionView()
    }
    .padding(.horizontal, 20)
    .padding(.top, 40)
  }
  
  @ViewBuilder
  private func characterImageView() -> some View {
    AMDImage.onbCharacter.swiftUIImage
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 100, height: 100)
  }
  
  @ViewBuilder
  private func recommendationTextView() -> some View {
    HStack(spacing: 0) {
      Text("**님의 일일 권장 당 섭취량은 ")
        .amdFont(.largeRegular)
        .foregroundColor(.gray80)
      
      Text("200g")
        .amdFont(.largeBold)
        .foregroundColor(.gray80)
      
      Text("이당!")
        .amdFont(.largeRegular)
        .foregroundColor(.gray80)
    }
  }
  
  @ViewBuilder
  private func goalSelectionView() -> some View {
    VStack(spacing: 10) {
      ForEach([SugarGoal.easy, SugarGoal.normal, SugarGoal.hard], id: \.self) { goal in
        SugarGoalOptionView(
          goal: goal,
          isSelected: selectedGoal == goal
        ) {
          selectedGoal = goal
        }
      }
    }
  }
  
  @ViewBuilder
  private func bottomInfoView() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("아맞당은 *WHO 세계 표준 권장 당류 가이드라인을 기준으로 일일 권장 당 섭취량을 산출하고 있어요.")
        .amdFont(.xsmallRegular)
        .foregroundColor(.gray50)
      
      Text("*WHO 세계 권장 당류 가이드라인: 1일 에너지 필요량의 10%")
        .amdFont(.xsmallRegular)
        .foregroundColor(.gray50)
    }
    .padding(.top, 24)
    .padding(.horizontal, 20)
  }
  
  @ViewBuilder
  private func bottomButtonView() -> some View {
    AMDButton(
      type: .default,
      title: "다음"
    ) {
      viewModel.handleAction(.moveToNextStep)
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 50)
  }
}

private struct SugarGoalOptionView: View {
  let goal: SugarGoal
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 16) {
        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
          .foregroundColor(isSelected ? .amdPrimary : .gray25)
          .font(.system(size: 24))
        
        VStack(alignment: .leading, spacing: 4) {
          Text(goal.rawValue)
            .amdFont(.mediumBold)
            .foregroundColor(.gray85)
          
          Text(goal.description)
            .amdFont(.smallRegular)
            .foregroundColor(.gray60)
        }
        
        Spacer()
        
        Text(goal.targetAmount)
          .amdFont(.mediumRegular)
          .foregroundColor(.primaryDarker)
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
