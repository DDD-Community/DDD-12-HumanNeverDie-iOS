//
//  SettingBottomButton.swift
//  SettingFeature
//
//  Created by Seulki Lee on 7/19/25.
//

import SwiftUI
import DesignSystem

public struct SettingBottomButton: View {
  public let type: AMDButton.AMDButtonType
  public let action: () -> Void

  public var body: some View {
    AMDButton(
      type: type,
      title: "저장",
      action: action
    )
    .padding(.horizontal, 20)
    .padding(.bottom, 50)
  }
}
