//
// OnboardingView.swift
// Onboarding
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

import DesignSystem
import CommonFeature

public struct OnboardingView: View {
  @State private var viewModel: OnboardingViewModel
  @Environment(Router.self) private var router
  @State private var currentPage = 0
  let totalPages = 3
  
  public init(viewModel: OnboardingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      topNavigationView()
      pageContentView()
      bottomNavigationView()
    }
    .background(Color.white)
    .ignoresSafeArea(edges: .bottom)
  }
  
  @ViewBuilder
  private func topNavigationView() -> some View {
    ZStack {
      HStack(spacing: 4) {
        ForEach(0..<totalPages, id: \.self) { index in
          if currentPage != index {
            Circle()
              .fill(index == currentPage ? Color.cyan : .gray40)
              .frame(width: 8, height: 8)
              .animation(.easeInOut(duration: 0.3), value: currentPage)
          } else {
            RoundedRectangle(cornerRadius: 15)
              .fill(index <= currentPage ? .amdPrimary : .gray40)
              .frame(width: 17, height: 8)
              .animation(.easeInOut(duration: 0.3), value: currentPage)
          }
        }
      }
      
      HStack {
        Spacer()
        Button("건너뛰기") {
          // 건너뛰기 액션
        }
        .foregroundColor(.amdPrimary)
        .amdFont(.mediumRegular)
      }
    }
    .padding(.horizontal, 30)
    .padding(.top, 20)
  }
  
  
  @ViewBuilder
  private func pageContentView() -> some View {
    TabView(selection: $currentPage) {
      OnboardingPageView(
        title: "아맞당에서는 커피 음료에\n숨겨진 당류를 확인할 수 있당!",
        pageNumber: 0
      )
      .tag(0)
      
      OnboardingPageView(
        title: "음료를 기록하면 나 고미당이\n당류 섭취량을 한눈에 알려준당!",
        pageNumber: 1
      )
      .tag(1)
      
      OnboardingPageView(
        title: "매일 매일 간편한 기록으로\n건강한 습관을 함께 만들어간당!",
        pageNumber: 2
      )
      .tag(2)
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    .animation(.easeInOut, value: currentPage)
  }

  @ViewBuilder
  private func bottomNavigationView() -> some View {
    VStack(spacing: 20) {
      Button(action: {
        // 시작하기 액션
      }) {
        
        AMDButton(
          type: .default,
          title: "아맞당 시작하기"
        ) {
          router.push(to: .onboardingProfile)
        }
      }
      .padding(.horizontal, 20)
      .opacity(currentPage == totalPages - 1 ? 1 : 0)
      .animation(.easeInOut(duration: 0.3), value: currentPage)
      .allowsHitTesting(currentPage == totalPages - 1)
    }
    .padding(.bottom, 36)
  }
}

extension OnboardingView {
  struct OnboardingPageView: View {
    let title: String
    let pageNumber: Int
    
    var body: some View {
      VStack(spacing: 40) {
        Spacer()
        
        Text(title)
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.black)
          .multilineTextAlignment(.center)
          .lineSpacing(4)
          .padding(.horizontal, 40)
          .padding(.top, -80)
        
        Spacer()
        
        AMDImage.homeHealthyCharacter.swiftUIImage
         .resizable()
         .scaledToFill()
         .frame(width: 200, height: 200)
         .padding(.top, 34)
        
        Spacer()
      }
    }
  }
}

