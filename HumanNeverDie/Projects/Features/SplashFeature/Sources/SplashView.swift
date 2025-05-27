//
// SplashView.swift
// Splash
//
// Created by 김규철 on 2025.
//

import SwiftUI

import CommonFeature

public struct SplashView: View {
  @State private var viewModel: SplashViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: SplashViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
  
  public var body: some View {
    ZStack {
      Color.pink
        .ignoresSafeArea()
      
      VStack {
        Image(systemName: "star.fill")
          .font(.system(size: 80))
          .foregroundColor(.white)
        
        Text("휴먼네버다이")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding(.top, 16)
        
        Text("스플래시 화면 입니다.")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding(.top, 16)
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation {
          router.setRoute(.main)
        }
      }
    }
  }
}
