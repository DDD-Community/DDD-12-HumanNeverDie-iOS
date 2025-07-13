//
//  PermissionView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/12/25.
//

import SwiftUI
import DesignSystem
import CommonFeature

struct PermissionView: View {
  @State private var viewModel: OnboardingProfileViewModel
  @Environment(Router.self) private var router
  
  public init(viewModel: OnboardingProfileViewModel) {
    self._viewModel = .init(initialValue: viewModel)
  }
    
  var body: some View {
    VStack(spacing: 0) {
      contentView()
    }
    .background(Color.white)
    .ignoresSafeArea(edges: .all)
    .onTapGesture {
      withAnimation(.easeInOut) {
        router.setRoute(.main)
      }
     }
  }
}

extension PermissionView {
  @ViewBuilder
  private func contentView() -> some View {
    VStack(spacing: 20) {

      bellIconView()
      messageView()
      
    }
    .padding(.horizontal, 20)
  }
  
  @ViewBuilder
  private func bellIconView() -> some View {
    ZStack {
      AMDImage.alertCircle.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)

    }
  }
  
  @ViewBuilder
  private func messageView() -> some View {
    VStack(spacing: 4) {
      Text("알림을 허용하시면")
        .amdFont(.largeRegular)
        .foregroundColor(.gray80)
      
      Text("리마인드 알림을 보내드려요")
        .amdFont(.largeBold)
        .foregroundColor(.gray80)
    }
    .multilineTextAlignment(.center)
  }
}
