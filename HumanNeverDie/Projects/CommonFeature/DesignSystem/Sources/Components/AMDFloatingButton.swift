//
//  AMDFloatingButton.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 7/1/25.
//

import SwiftUI

public struct AMDFloatingButton: View {
  private let type: AMDFloatingButtonType
  private let title: String
  private let leftIcon: Image?
  private let rightIcon: Image?
  private let action: () -> Void
  
  public enum AMDFloatingButtonType {
    case `default`
    case secondary
  }
  
  public init(
    type: AMDFloatingButtonType = .default,
    title: String,
    leftIcon: Image? = nil,
    rightIcon: Image? = nil,
    action: @escaping () -> Void
  ) {
    self.type = type
    self.title = title
    self.leftIcon = leftIcon
    self.rightIcon = rightIcon
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack(spacing: 4) {
        if let leftIcon = leftIcon {
          icon(leftIcon)
        }
        
        Text(title)
        
        if let rightIcon = rightIcon {
          icon(rightIcon)
        }
      }
    }
    .buttonStyle(AMDFloatingButtonStyle(type: type))
  }
  
  private func icon(_ icon: Image) -> some View {
    icon
      .resizable()
      .scaledToFill()
      .frame(width: 24, height: 24)
  }
}

fileprivate struct AMDFloatingButtonStyle: ButtonStyle {
  private let type: AMDFloatingButton.AMDFloatingButtonType
  
  fileprivate init(type: AMDFloatingButton.AMDFloatingButtonType) {
    self.type = type
  }
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(font(type))
      .foregroundColor(foregroundColor(type))
      .frame(height: 52)
      .padding(.horizontal, 20)
      .background(backgroundColor(type, configuration))
      .amdStrokeBorder(strokeBorderColor(type), linewidth: strokeBorderWidth(type))
      .if(type == .default) {
        $0.amdShadow(.fab)
      }
      .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
  
  private func font(_ type: AMDFloatingButton.AMDFloatingButtonType) -> Font {
    switch type {
    case .default:
      return AMDFont.largeBold.swiftUIFont
      
    case .secondary:
      return AMDFont.largeBold.swiftUIFont
    }
  }
  
  private func foregroundColor(_ type: AMDFloatingButton.AMDFloatingButtonType) -> Color {
    switch type {
    case .default:
      return .white
      
    case .secondary:
      return .gray85
    }
  }
  
  private func backgroundColor(_ type: AMDFloatingButton.AMDFloatingButtonType, _ configuration: Configuration) -> Color {
    switch type {
    case .default:
      return configuration.isPressed ? .primaryDarker : .amdPrimary
      
    case .secondary:
      return .white
    }
  }
  
  private func strokeBorderColor(_ type: AMDFloatingButton.AMDFloatingButtonType) -> Color {
    switch type {
    case .default:
      return .clear
      
    case .secondary:
      return .gray25
    }
  }
  
  private func strokeBorderWidth(_ type: AMDFloatingButton.AMDFloatingButtonType) -> CGFloat {
    switch type {
    case .default:
      return 0
      
    case .secondary:
      return 1
    }
  }
}
