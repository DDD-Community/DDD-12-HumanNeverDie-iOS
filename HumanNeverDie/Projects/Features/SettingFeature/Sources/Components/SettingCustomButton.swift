//
//  SettingCustomButton.swift
//  SettingFeature
//
//  Created by Seulki Lee on 8/15/25.
//

import SwiftUI
import DesignSystem

public struct SettingCustomButton: View {
  private let title: String
  private let progressText: String
  private let action: () -> Void
  
  public init(
    title: String,
    progressText: String,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.progressText = progressText
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack(spacing: 12) {
        
        AMDImage.flag24.swiftUIImage
          .font(.system(size: 24, weight: .medium))
        
        Text(title)
          .amdFont(.mediumBold)
          .foregroundColor(.gray85)
        
        Spacer()
        
        Text(progressText)
          .amdFont(.mediumRegular)
          .foregroundColor(.amdPrimary)
        
        Image(systemName: "chevron.right")
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(.gray40)
      }
      .frame(maxWidth: .infinity, alignment: .center)
    }
    .buttonStyle(ProgressButtonStyle())
  }
}

fileprivate struct ProgressButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .amdFont(.largeBold)
      .foregroundStyle(.gray50)
      .frame(height: 52)
      .padding(.horizontal, 14)
      .background(.primaryBackground)
      .amdCornerRadius(.medium)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.bouncy(duration: 0.6, extraBounce: 0.2), value: configuration.isPressed)
  }
}
