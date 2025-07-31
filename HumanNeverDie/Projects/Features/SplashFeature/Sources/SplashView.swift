//
// SplashView.swift
// Splash
//
// Created by 김규철 on 2025.
//

import SwiftUI
import DesignSystem
import CommonFeature

public struct SplashView: View {
  @State private var viewModel: SplashViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: SplashViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ZStack {
      AMDImage.splash.swiftUIImage
        .resizable()
        .scaledToFill()
        .ignoresSafeArea(.all)
    }
    .onChange(of: viewModel.isInitializationComplete) { _, isInitializationComplete in
      if isInitializationComplete {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation {
            router.setRoute(.main)
          }
        }
      }
    }
    .onAppear {
      viewModel.handleAction(.onAppear)
    }
  }
}
