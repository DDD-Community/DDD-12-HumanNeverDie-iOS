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
    OnboardingTopHeaderView(
      title: "일일 당 섭취량 목표를\n정해주세요",
      stepText: "3/3"
    )
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    VStack(spacing: 32) {
      VStack(spacing: 0) {
        characterImageView()
        speechbubbleTextView()
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
  private func speechbubbleTextView() -> some View {
    let baseTextColor = Color.gray80
    ZStack(alignment: .top) {
      
      SpeechBubbleTriangle()
        .fill(Color.gray10)
        .frame(width: 24, height: 22)
        .offset(y: -13)
      
      HStack(spacing: 0) {
        Text("\(viewModel.nickname)님의 일일 권장 당 섭취량은 ")
          .amdFont(.largeRegular)
          .foregroundColor(baseTextColor)
        
        Text("200g")
          .amdFont(.largeBold)
          .foregroundColor(baseTextColor)
        
        Text("이당!")
          .amdFont(.largeRegular)
          .foregroundColor(baseTextColor)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 12)
      .background(Color.gray10)
      .cornerRadius(16)
    }
    .padding(.top, 12)
    
  }
  
  struct SpeechBubbleTriangle: Shape {
    func path(in rect: CGRect) -> Path {
      var path = Path()
      path.move(to: CGPoint(x: rect.midX, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
      path.closeSubpath()
      return path
    }
  }
  
  @ViewBuilder
  private func goalSelectionView() -> some View {
    VStack(spacing: 10) {
      ForEach([SugarGoal.easy, SugarGoal.normal, SugarGoal.hard], id: \.self) { dailyGoal in
        SugarGoalOptionView(
          dailyGoal: dailyGoal,
          isSelected: viewModel.state.selectedDailySugarGoal == dailyGoal
        ) {
          viewModel.handleAction(.updateDailySugarGoal(dailyGoal))
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
    OnboardingBottomButton(
      type: viewModel.isValidDailySugarGoal ? .default : .secondary
    ) {
      guard viewModel.isValidDailySugarGoal else { return }
      viewModel.handleAction(.moveToNextStep)
    }
  }
}

private struct SugarGoalOptionView: View {
  let dailyGoal: SugarGoal
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 16) {
        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
          .foregroundColor(isSelected ? .amdPrimary : .gray25)
          .font(.system(size: 24))
        
        VStack(alignment: .leading, spacing: 4) {
          Text(dailyGoal.rawValue)
            .amdFont(.mediumBold)
            .foregroundColor(.gray85)
          
          Text(dailyGoal.description)
            .amdFont(.smallRegular)
            .foregroundColor(.gray60)
        }
        
        Spacer()
        
        Text(dailyGoal.targetAmount)
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
