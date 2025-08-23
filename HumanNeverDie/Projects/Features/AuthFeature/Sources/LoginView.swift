//
// LoginView.swift
// Auth
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature
import DesignSystem

public struct LoginView: View {
  @State private var viewModel: LoginViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: LoginViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Spacer()
      Spacer()
      
      contentSection
      
      Spacer()
      Spacer()
      Spacer()
      
      appleLoginButton
    }
    .ignoresSafeArea()
    .background(.white)
    .onChange(of: viewModel.route) { _, route in
      guard let route else { return }
      withAnimation {
        router.setRoute(route)
      }
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
  }
  
  private var contentSection: some View {
    VStack(alignment: .center, spacing: 24) {
      characterImage
      logoSection
    }
  }
  
  private var characterImage: some View {
    AMDImage.homeHealthyCharacter.swiftUIImage
      .resizable()
      .scaledToFit()
      .frame(width: 295, height: 216)
      .padding(.horizontal, 40)
  }
  
  private var logoSection: some View {
    VStack(alignment: .center, spacing: 16) {
      AMDImage.loginLogo.swiftUIImage
      
      Text("카페 음료, 이제 똑똑하게 즐겨요!")
        .amdFont(.mediumMedium)
        .foregroundStyle(.gray85)
        .frame(maxWidth: .infinity, alignment: .center)
    }
  }
  
  private var appleLoginButton: some View {
    Button {
      viewModel.handleAction(.loginButtonTapped)
    } label: {
      HStack(alignment: .center, spacing: 8) {
        AMDImage.appleLoginIcon.swiftUIImage
        appleLoginText
      }
      .frame(maxWidth: .infinity, minHeight: 52, maxHeight: 52)
      .background(.black)
      .clipShape(RoundedRectangle(cornerRadius: 13))
    }
    .disabled(viewModel.state.isLoading)
    .padding(.horizontal, 20)
    .padding(.bottom, 100)
  }
  
  private var appleLoginText: some View {
    HStack(spacing: 0) {
      Text("Apple")
        .amdFont(.largeBold)
        .foregroundColor(.white)
      
      Text("로 계속하기")
        .amdFont(.largeRegular)
        .foregroundColor(.white)
    }
  }
}
