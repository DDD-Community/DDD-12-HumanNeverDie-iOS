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
    ZStack {
      AMDImage.splash.swiftUIImage
        .resizable()
        .scaledToFill()
        .ignoresSafeArea(.all)
    }
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
}
