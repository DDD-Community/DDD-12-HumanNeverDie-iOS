//
//  AMDButton.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 6/30/25.
//

import SwiftUI

public struct AMDButton: View {
  private let type: AMDButtonType
  private let title: String
  private let action: () -> Void
  
  public enum AMDButtonType {
    case `default`
    case teriary
    case secondary
    case delete
  }
  
  public enum AMDButtonState {
    case `default`
    case pressed
    case disabled
  }
  
  public init(
    type: AMDButtonType = .default,
    title: String,
    action: @escaping () -> Void
  ) {
    self.type = type
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      Text(title)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    .buttonStyle(AMDButtonStyle(type: type))
  }
}

fileprivate struct AMDButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled
  
  private let type: AMDButton.AMDButtonType
  
  fileprivate init(type: AMDButton.AMDButtonType) {
    self.type = type
  }
  
  func makeBody(configuration: Configuration) -> some View {
    let state = buttonState(configuration)
    
    configuration.label
      .amdFont(.largeBold)
      .foregroundStyle(foregroundColor(type, state))
      .frame(height: 52)
      .padding(.horizontal, 13)
      .background(backgroundColor(type, state))
      .amdCornerRadius(.medium)
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.bouncy(duration: 0.6, extraBounce: 0.2), value: configuration.isPressed)
  }
  
  private func buttonState(_ configuration: Configuration) -> AMDButton.AMDButtonState {
    guard isEnabled else { return .disabled }
    
    if configuration.isPressed { return .pressed }
    
    return .default
  }
  
  private func foregroundColor(_ type: AMDButton.AMDButtonType, _ state: AMDButton.AMDButtonState) -> Color {
    switch (type, state) {
    case (.secondary, _):
      return .gray80
      
    case (.delete, _):
      return .danger
      
    default:
      return .white
    }
  }
  
  private func backgroundColor(_ type: AMDButton.AMDButtonType, _ state: AMDButton.AMDButtonState) -> Color {
    switch (type, state) {
    case (.default, .default):
      return .amdPrimary
      
    case (.default, .pressed):
      return .primaryDarker
      
    case (.default, .disabled):
      return .gray50
      
    case (.secondary, _):
      return .gray15
      
    case (.delete, _):
      return .dangerBackground
    case (.teriary, _):
      
      return .gray50
    }
  }
}

