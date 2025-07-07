//
// OnboardingView.swift
// Onboarding
//
// Created by Seulki Lee on 2025.
//

import SwiftUI

import CommonFeature

public struct OnboardingView: View {
  @State private var viewModel: OnboardingViewModel
  @State private var currentPage = 0
  let totalPages = 3
  
  public init(viewModel: OnboardingViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      // 상단 진행 바
      HStack {
        HStack(spacing: 4) {
          ForEach(0..<totalPages, id: \.self) { index in
            if currentPage != index {
              Circle()
                .fill(index == currentPage ? Color.cyan : Color.gray.opacity(0.3))
                .frame(width: 8, height: 8)
                .animation(.easeInOut(duration: 0.3), value: currentPage)
            } else {
              RoundedRectangle(cornerRadius: 15)
                .fill(index <= currentPage ? Color.red : Color.gray.opacity(0.3))
                .frame(width: 17, height: 8)
                .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
          }
        }.frame(maxWidth: .infinity, alignment: .center)
        
        Spacer()
        
        Button("건너뛰기") {
          // 건너뛰기 액션
        }
        .foregroundColor(.cyan)
        .font(.system(size: 16))
      }
      .padding(.horizontal, 30)
      .padding(.top, 20)
      
      
      // 페이지 컨텐츠
      TabView(selection: $currentPage) {
        OnboardingPageView(
          title: "아맞당에서는 커피 음료에\n숨겨진 당류를 확인할 수 있당!",
          pageNumber: 0
        )
        .tag(0)
        
        OnboardingPageView(
          title: "음료를 기록하면 나 고미랑이\n당류 섭취량을 한눈에 알려준당!",
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
      
      // 하단 네비게이션
      VStack(spacing: 20) {
        
        // 시작하기 버튼 (마지막 페이지에서만 표시)
        if currentPage == totalPages - 1 {
          Button(action: {
            // 시작하기 액션
          }) {
            Text("이맘당 시작하기")
              .font(.system(size: 18, weight: .semibold))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .frame(height: 56)
              .background(Color.cyan)
              .cornerRadius(28)
          }
          .padding(.horizontal, 30)
          .transition(.opacity.combined(with: .scale))
        }
      }
      .padding(.bottom, 50)
    }
    .background(Color.white)
    .ignoresSafeArea(edges: .bottom)
  }
  
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
        
        // 일러스트레이션 영역 (placeholder)
        Rectangle()
          .fill(Color.gray.opacity(0.1))
          .frame(width: 200, height: 200)
          .cornerRadius(20)
          .overlay(
            Text("일러스트\n\(pageNumber + 1)")
              .font(.system(size: 24, weight: .medium))
              .foregroundColor(.gray)
              .multilineTextAlignment(.center)
          )
        
        Spacer()
      }
    }
  }
}
