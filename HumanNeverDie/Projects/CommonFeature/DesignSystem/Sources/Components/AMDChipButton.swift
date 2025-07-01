//
//  AMDChipButton.swift
//  DesignSystem
//
//  Created by 김규철 on 6/24/25.
//

import SwiftUI

public struct AMDChipButton: View {
  private let title: String
  private let isSelected: Bool
  private let action: () -> Void
  
  public init(
    title: String,
    isSelected: Bool,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.isSelected = isSelected
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      Text(title)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    .buttonStyle(AMDChipButtonStyle(isSelected: isSelected))
  }
}

fileprivate struct AMDChipButtonStyle: ButtonStyle {
  private let isSelected: Bool
  
  init(isSelected: Bool) {
    self.isSelected = isSelected
  }
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .amdFont(.mediumMedium)
      .foregroundStyle(foregroundColor(isSelected))
      .frame(height: 48)
      .padding(.horizontal, 13)
      .background(backgroundColor(isSelected))
      .amdStrokeBorder(strokeBorderColor(isSelected))
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.bouncy(duration: 0.6, extraBounce: 0.2), value: configuration.isPressed)
  }
  
  private func foregroundColor(_ isSelected: Bool) -> Color {
    return isSelected ? .primaryDarker : .gray70
  }
  
  private func backgroundColor(_ isSelected: Bool) -> Color {
    return isSelected ? .primaryBackground : .white
  }
  
  private func strokeBorderColor(_ isSelected: Bool) -> Color {
    return isSelected ? .amdPrimary : .gray25
  }
}

#Preview {
  AMDChipButton(title: "남성", isSelected: false, action: {})
}
