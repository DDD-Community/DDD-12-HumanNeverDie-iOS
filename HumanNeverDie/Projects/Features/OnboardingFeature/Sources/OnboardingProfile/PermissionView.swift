//
//  PermissionView.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/12/25.
//

import SwiftUI
import DesignSystem

struct PermissionView: View {
  
  var body: some View {
    VStack(spacing: 0) {
      contentView()
    }
    .background(Color.white)
    .ignoresSafeArea(edges: .all)
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

struct NotificationPermissionView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PermissionView()
        .previewDisplayName("Static")
    }
  }
}
