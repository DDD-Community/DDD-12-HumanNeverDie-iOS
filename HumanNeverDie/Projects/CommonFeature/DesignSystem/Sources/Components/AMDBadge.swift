//
//  AMDBadge.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 6/25/25.
//

import SwiftUI

public struct AMDBadge: View {
  private let title: String
  private let type: BadgeType
  
  public init(
    title: String,
    type: BadgeType
  ) {
    self.title = title
    self.type = type
  }
  
  public enum BadgeType {
    case yellow
    case primary
    
    fileprivate var fontColor: Color {
      switch self {
      case .yellow:
        return .yellowDarker
      case .primary:
        return .primaryDarker
      }
    }
    
    fileprivate var backgroundColor: Color {
      switch self {
      case .yellow:
        return .yellowBackground
      case .primary:
        return .primaryBackground
      }
    }
  }
  
  public var body: some View {
    Text(title)
      .amdFont(.smallRegular)
      .foregroundStyle(type.fontColor)
      .padding(.horizontal, 8)
      .frame(height: 24)
      .background(type.backgroundColor)
      .amdCornerRadius(.small)
  }
}

#Preview {
  AMDBadge(title: "무당", type: .yellow)
}
