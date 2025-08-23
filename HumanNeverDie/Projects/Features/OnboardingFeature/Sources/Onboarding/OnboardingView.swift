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
  @State private var currentPage = 0
  @Environment(Router.self) private var router
  private let totalPages = 3
  
  public init(viewModel: OnboardingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      topNavigationView()
      pageContentView()
      bottomNavigationView()
    }
    .background(.gray0)
    .ignoresSafeArea(edges: .bottom)
  }
}

extension OnboardingView {
  
  @ViewBuilder
  private func topNavigationView() -> some View {
    ZStack {
      HStack(spacing: 4) {
        ForEach(0..<totalPages, id: \.self) { index in
          if currentPage != index {
            Circle()
              .fill(.gray40)
              .frame(width: 8, height: 8)
              .animation(.easeInOut(duration: 0.3), value: currentPage)
          } else {
            RoundedRectangle(cornerRadius: 15)
              .fill(.amdPrimary)
              .frame(width: 17, height: 8)
              .animation(.easeInOut(duration: 0.3), value: currentPage)
          }
        }
      }
      
      HStack {
        Spacer()
        
        Button("건너뛰기") {
          pushProfileView()
        }
        .opacity(currentPage == totalPages - 1 ? 0 : 1)
        .foregroundColor(.primaryDarker)
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
        title: "아맞당에서는 카페 음료에\n숨겨진 당류를 확인할 수 있당!",
        image:  AMDImage.onbWelcome1,
        pageNumber: 0
      )
      .tag(0)
      
      OnboardingPageView(
        title: "음료를 기록하면 나 고미당이\n당류 섭취량을 한눈에 알려준당!",
        image:  AMDImage.onbWelcome2,
        pageNumber: 1
      )
      .tag(1)
      
      OnboardingPageView(
        title: "매일 매일 간편한 기록으로\n건강한 습관을 함께 만들어간당!",
        image:  AMDImage.onbWelcome3,
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
      AMDButton(
        type: .default,
        title: "아맞당 시작하기"
      ) {
        pushProfileView()
      }
      .padding(.horizontal, 20)
      .opacity(currentPage == totalPages - 1 ? 1 : 0)
      .animation(.easeInOut(duration: 0.3), value: currentPage)
      .allowsHitTesting(currentPage == totalPages - 1)
    }
    .padding(.bottom, 36)
  }
  
  private struct OnboardingPageView: View {
    let title: String
    let image: DesignSystemImages
    let pageNumber: Int
    
    var body: some View {
      GeometryReader { geometry in
        VStack(spacing: 0) {
          VStack {
            Text(title)
              .amdFont(.xxlargeBold)
              .foregroundColor(.gray80)
              .multilineTextAlignment(.center)
          }
          .frame(height: geometry.size.height * 0.25)
      
          image.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(
              width: geometry.size.width * 0.9,
              height: geometry.size.height * 0.75
            )
            .clipped()

        }.frame(maxWidth: .infinity)
      }
    }
  }
  
  private func pushProfileView() {
    router.push(to: .onboardingProfile)
  }
}


