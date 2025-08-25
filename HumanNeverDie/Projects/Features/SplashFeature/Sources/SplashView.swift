//
// SplashView.swift
// Splash
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature
import DesignSystem

public struct SplashView: View {
  @State private var viewModel: SplashViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: SplashViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .top) {
        lottieAnimationSection(geometry: geometry)
        backgroundView
        logoSection
      }
    }
    .background(Color.white)
    .onChange(of: viewModel.route) { _, route in
      guard let route else { return }
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation {
          router.setRoute(route)
        }
      }
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
  }
  
  func lottieAnimationSection(geometry: GeometryProxy) -> some View {
    VStack(spacing: 0) {
      Spacer()
      
      Spacer()
      
      AMDLottieView(asset: .splash)
        .frame(width: geometry.size.width, height: 270)
        .aspectRatio(contentMode: .fill)
        .scaleEffect((geometry.size.width + 20) / 375)
        .clipped()
    }
    .ignoresSafeArea()
  }
  
  private var backgroundView: some View {
    ZStack(alignment: .bottomTrailing) {
      AMDImage.splashBackground.swiftUIImage
        .resizable()
        .scaledToFit()
        .ignoresSafeArea()
      
      AMDImage.splashStarIcon.swiftUIImage
        .padding(.trailing, 20)
        .padding(.bottom, 120)
    }
  }
  
  private var logoSection: some View {
    VStack(spacing: 0) {
      Spacer()
      
      VStack(alignment: .center, spacing: 20) {
        Text("카페 음료, 이제 똑똑하게 즐겨요!")
          .amdFont(.mediumMedium)
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity, alignment: .center)
        
        AMDImage.loginLogo.swiftUIImage
          .renderingMode(.template)
          .foregroundStyle(.white)
      }
      
      Spacer()
      
      Spacer()
      
      Spacer()
      
      Spacer()
      
      Spacer()
    }
  }
}

