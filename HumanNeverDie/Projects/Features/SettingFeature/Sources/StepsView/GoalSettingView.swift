//
//  GoalSettingView.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI

import UserDomain
import DesignSystem
import CommonFeature

public struct GoalSettingView: View {
  @State public var viewModel: GoalSettingViewModel
  @Environment(Router.self) private var router
  public init(viewModel: GoalSettingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        contentView()
        bottomInfoView()
        Spacer()
        bottomButtonView()
          .padding(.top, 30)
      }
    }
    .settingToolbar(item: .goalSetting) {
      self.router.pop()
    }
    .onAppear {
      viewModel.setRouter(router)
    }
  }
}

extension GoalSettingView {
  
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
        Text("\(viewModel.userInfo.nickname)님의 일일 권장 당 섭취량은 ")
          .amdFont(.largeRegular)
          .foregroundColor(baseTextColor)
        
        Text("\(viewModel.normalSugarAmount)g")
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
  
  private struct SpeechBubbleTriangle: Shape {
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
        AMDOptionButton(
          title: dailyGoal.descriptionTitle,
          subtitle: dailyGoal.description,
          trailingText: "하루 \(viewModel.getSugarGoalAmount(for: dailyGoal))g",
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
      HStack(spacing: 4) {
        Text("권장 당 섭취량 계산법이 궁금하다면?")
          .amdFont(.xsmallRegular)
          .foregroundColor(.gray85)
          .underline()
        
        Image(systemName: "chevron.right")
          .font(.system(size: 10))
          .foregroundColor(.gray70)
      }.onTapGesture {
        viewModel.handleAction(.showSugarCalculationInfo)
      }
      .amdBottomSheet(isPresented: $viewModel.state.isShowingSugarCalculationInfo, detents: [.height(800)]) {
        SugarCalculationInfoContent {
          viewModel.handleAction(.hideSugarCalculationInfo)
        }
      }
      
      Text("*아맞당은 카페 음료의 당류만 기록해요. 식사나 간식 등 다른 경로로 섭취 한 당류는 고려하지 않으니 참고해주세요.")
        .amdFont(.xsmallRegular)
        .foregroundColor(.gray60)
    }
    .padding(.top, 24)
    .padding(.horizontal, 20)
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
}

