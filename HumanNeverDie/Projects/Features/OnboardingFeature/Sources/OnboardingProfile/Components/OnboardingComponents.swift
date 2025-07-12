//
//  OnboardingComponents.swift
//  OnboardingFeature
//
//  Created by Seulki Lee on 7/13/25.
//

import SwiftUI
import DesignSystem

struct OnboardingTopHeaderView: View {
  let title: String
  let stepText: String
  
  var body: some View {
    HStack(alignment: .lastTextBaseline) {
      Text(title)
        .amdFont(.xxlargeBold)
        .foregroundColor(.gray80)
        .multilineTextAlignment(.leading)
      
      Spacer()
      
      Text(stepText)
        .amdFont(.smallRegular)
        .foregroundColor(.gray50)
        .multilineTextAlignment(.trailing)
    }
    .padding(.horizontal, 20)
  }
}

struct OnboardingBottomButton: View {
  let type: AMDButton.AMDButtonType
  let action: () -> Void

  var body: some View {
    AMDButton(
      type: type,
      title: "다음",
      action: action
    )
    .padding(.horizontal, 20)
    .padding(.bottom, 50)
  }
}
